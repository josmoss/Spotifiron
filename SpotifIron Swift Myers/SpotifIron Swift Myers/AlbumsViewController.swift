//
//  AlbumsViewController.swift
//  SpotifIron Swift Myers
//
//  Created by Joe Moss on 6/17/16.
//  Copyright © 2016 Dragoman Developers, LLC. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let session = NSURLSession.sharedSession()
    
    var albumnArray = [Albumn]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK : Table View Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView .dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        return cell
        
    }

    func fetchAlbumn(albumn : String) {

        print("fetchArtist query value is \(albumn)")
        
        self.albumnArray.removeAll
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
