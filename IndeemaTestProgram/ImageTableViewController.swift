//
//  ViewController.swift
//  IndeemaTestProgram
//
//  Created by Pavlo Dumyak on 10.03.16.
//  Copyright © 2016 Pavlo Dumyak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
   
    var imageNames: [String]?
 //   var imageDataSource:[]
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTable()
        prepareDataSource()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    func prepareDataSource() {
        imageNames = Array(DataSource.dataSourceDictionary.keys)
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageNames?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ImageTableViewCell.reuseIdentifier, forIndexPath: indexPath) as? ImageTableViewCell
        cell?.startDownloadingButton.tag = indexPath.row
        cell?.clear()
        let name = imageNames![indexPath.row]
        if DataSource.imageDataSource[name] == nil {
            cell?.fillWithInfo(imageNames![indexPath.row], image: UIImage(named: "NoImage")!)
        } else {
            cell?.fillWithInfo(imageNames![indexPath.row], image: DataSource.imageDataSource[name]!)

        }
        return cell!
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? ImageDetailViewController {
            let cell = sender as? ImageTableViewCell
            controller.image = cell?.superHeroImageView.image
        }
    }

}

