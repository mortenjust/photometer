//
//  ViewController.swift
//  Photometer
//
//  Created by Morten Just Petersen on 12/20/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import UIKit
import Photos


class ViewController: UIViewController, PhotoTableAdapterDelegate {
    var fetcher:PhotoFetcher!
    var adapter:PhotoTableAdapter!
    @IBOutlet weak var photoTable: UITableView!
    var currentMeterImage:MeterImage!
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }
    
    func PhotoTableWantsFetchUpdate() {
        refreshPhotoList()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        
        view.backgroundColor = C.appBackgroundColor
        
        prefersStatusBarHidden()
        
        adapter = PhotoTableAdapter()
        adapter.photoTable = photoTable
        adapter.adapterDelegate = self
        adapter.vc = self
        
        photoTable.separatorStyle = .None
        photoTable.dataSource = adapter
        photoTable.delegate = adapter
        photoTable.backgroundColor = C.photoTableBackgroundColor
    
        fetcher = PhotoFetcher()        
        refreshPhotoList()
    }
    
    func PhotoFetcherLibraryChanged() {
        refreshPhotoList()
        print("lib changed!")
    }
    
    func refreshPhotoList(){
        fetcher.getAll { (photos) -> Void in
            print("Done getting all \(photos.count) images. Reloading data")
            self.adapter.allPhotos = photos
            self.photoTable.reloadData()
            self.photoTable.contentOffset = CGPointMake(0, 128)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let detailVc = segue.destinationViewController as! DetailViewController
            detailVc.meterImage = currentMeterImage
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

