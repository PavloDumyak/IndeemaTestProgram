import UIKit

class LoadImageOperation: ConcurrentOperation {
    var imagePath: String?
    var image: UIImage?
    var task: NSURLSessionDataTask?
    init(imagePath: String) {
        super.init()
        self.imagePath = imagePath
    }
    
    override func main() {
        
        guard let imagePath = imagePath else { return }
        guard let imageUrl = NSURL(string: imagePath) else { return }
    
        task = NSURLSession.sharedSession().dataTaskWithURL(imageUrl, completionHandler: { (data, response, error) -> Void in
            if let checkData = data {
                let imageData = UIImage(data: checkData)
                self.image = imageData
            }
            self.state = .Finished
        })
        task!.resume()
    }
}

class ImageLoader {
    lazy var loadingQueue = NSOperationQueue()
    lazy var activeDownloads: [String: (operation: LoadImageOperation?, completions: [(UIImage?) -> Void])] = [:]
    var loadOperation: LoadImageOperation?
    
    func fetchImageWithUrl(imageUrl: String, completionBlock: (UIImage?) -> Void) {
            loadImageWithUrl(imageUrl, completionBlock: completionBlock)
    }
    
    private func loadImageWithUrl(imageUrl: String, completionBlock: (UIImage?) -> Void) {
        addCompletion(completionBlock, forKey: imageUrl)
        if let _ = activeDownloads[imageUrl]?.operation {
            return
        }
        
        loadOperation = LoadImageOperation(imagePath: imageUrl)
        loadOperation!.completionBlock = {
            dispatch_async(dispatch_get_main_queue()) {
                self.notifyCompletionsWithImage(self.loadOperation!.image, key: imageUrl)
                self.activeDownloads.removeValueForKey(imageUrl)
            }
        }
        activeDownloads[imageUrl]?.operation = loadOperation
        loadingQueue.addOperation(loadOperation!)
    }
    
    private func addCompletion(completionBlock: (UIImage?) -> Void, forKey key: String) {
        if activeDownloads.keys.contains(key) == false {
            activeDownloads[key] = (operation: nil, completions: [])
        }
        var completions = activeDownloads[key]?.completions ?? []
        
        completions.append(completionBlock)
        activeDownloads[key]?.completions = completions
    }
    
    private func notifyCompletionsWithImage(image: UIImage?, key: String) {
        guard let completions = activeDownloads[key]?.completions else { return }
        for completion in completions {
            completion(image)
        }
    }
        
}