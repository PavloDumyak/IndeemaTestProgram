//
//  ImageDetailViewController.swift
//  IndeemaTestProgram
//
//  Created by Pavlo Dumyak on 10.03.16.
//  Copyright © 2016 Pavlo Dumyak. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var superHeroImageView: UIImageView!
    
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.scrollEnabled = true
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 2.0
        scrollView.zoomScale = 1.0
        superHeroImageView.image = image
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return superHeroImageView
    }
    
}
