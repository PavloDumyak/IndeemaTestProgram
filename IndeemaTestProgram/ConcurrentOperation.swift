import UIKit

enum ConcurrentOperationState: String {
    case Ready, Executing, Finished
    
    var keyPath: String {
        return "is" + rawValue
    }
}

class ConcurrentOperation: NSOperation {
    var state = ConcurrentOperationState.Ready {
        willSet {
            willChangeValueForKey(state.keyPath)
            willChangeValueForKey(newValue.keyPath)
        }
        didSet {
            didChangeValueForKey(oldValue.keyPath)
            didChangeValueForKey(state.keyPath)
        }
    }
}

extension ConcurrentOperation {
    override var ready: Bool {
        return super.ready && state == .Ready
    }
    
    override var executing: Bool {
        return state == .Executing
    }
    
    override var finished: Bool {
        return state == .Finished
    }
    
    override var asynchronous: Bool {
        return true
    }
    
    override func start() {
        if cancelled {
            state = .Finished
            return
        }
        main()
        
        state = .Executing
    }
    
    override func cancel() {
        state = .Finished
    }
}