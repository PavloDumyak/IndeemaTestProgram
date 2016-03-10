//
//  ImageTableViewCell.swift
//  IndeemaTestProgram
//
//  Created by Pavlo Dumyak on 10.03.16.
//  Copyright © 2016 Pavlo Dumyak. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var superHeroImageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var startDownloadingButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var activityIndicatoHeightConstraint: NSLayoutConstraint!
   lazy var imageLoader = ImageLoader()
    
    static var reuseIdentifier: String {
        return "imageTableViewCellIdentifier"
    }

}

extension ImageTableViewCell {
    
    @IBAction func startDownloading(sender: AnyObject) {
        
        if startDownloadingButton.selected == false {
            activityIndicator.color = UIColor.redColor()
            activityIndicator.startAnimating()
            startDownloadingButton.selected = true
            guard let key = imageNameLabel.text else { return }
            imageLoader.fetchImageWithUrl(DataSource.dataSourceDictionary[key]!) { (image) -> Void in
                self.startDownloadingButton.selected = false
                if image == nil {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.color = UIColor.whiteColor()
                    DataSource.imageDataSource[key] = UIImage(named: "NoImage")
                    self.superHeroImageView.image = UIImage(named: "NoImage")
                } else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.color = UIColor.whiteColor()
                    DataSource.imageDataSource[key] = image
                    self.superHeroImageView.image = image
                }
            }
        } else {
            self.activityIndicator.color = UIColor.whiteColor()
            activityIndicator.stopAnimating()
            startDownloadingButton.selected = false
            guard let key = imageNameLabel.text else { return }
            let url = DataSource.dataSourceDictionary[key]!
            imageLoader.activeDownloads[url]?.operation?.cancel()
            imageLoader.loadingQueue.cancelAllOperations()
            imageLoader.loadOperation?.task?.cancel()
        }
    }
    
    func clear() {
        superHeroImageView.image = nil
    }
    
    func fillWithInfo(name: String, image: UIImage) {
        imageNameLabel.text = name
        superHeroImageView.image = image
    }
}