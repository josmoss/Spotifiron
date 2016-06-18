//
//  AlbumsViewController.swift
//  SpotifIron Swift Myers
//
//  Created by Joe Moss on 6/17/16.
//  Copyright © 2016 Dragoman Developers, LLC. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let session = NSURLSession.sharedSession()
    
    var albumArray = [Album]()
    
    var theArtist = Artist()
    
    var currentAlbum = Album()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchAlbum(theArtist.artistID)
    }
    
    // MARK : Table View Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView .dequeueReusableCellWithIdentifier("AlbumCell", forIndexPath: indexPath)
        
        self.currentAlbum = self.albumArray[indexPath.row]
        
        cell.textLabel?.text = self.currentAlbum.albumName
        
        return cell
    }

    func fetchAlbum(artistID : String) {

        print("fetchAlbum query value is \(artistID)")
        
        self.albumArray.removeAll()
        
        let albumURLString = "https://api.spotify.com/v1/artists/\(artistID)/albums"
        
        if let url = NSURL(string: albumURLString)
        {
            let task = self.session.dataTaskWithURL(url, completionHandler:
                {
                    (data, response, error) in
                    
                    if error != nil
                    {
                        print("An error occured")
                        return
                    }
                    do
                    {
                        if let data = data {
                            if let dict = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? JSONDictionary {
                                
                                   if let itemsArray = dict["items"] as? JSONArray {
                                    
                                        for itemsDict in itemsArray  {
                                            
                                            print("The item dict == \(itemsDict)")
                                          
                                            let theAlbum = Album()
                                            
                                            if let href = itemsDict["href"] as? String {
                                               theAlbum.href = href
                                            
                                            } else {
                                                print("I could not parse the href")
                                            }
                                           
                                            if let albumID = itemsDict["id"] as? String {
                                                theAlbum.albumID = albumID
                                                
                                            } else {
                                               print("I could not parse the albumID")
                                            }
                                            
                                            if let albumName = itemsDict["name"] as? String {
                                               theAlbum.albumName = albumName
                                    
                                            } else {
                                             print("I could not parse the albumName")
                                            }
                                    
                                           self.albumArray.append(theAlbum)
                                       }
                                    
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.tableView.reloadData()
                                    })
                                    
                                   } else {
                                       print("I could not parse the items")
                                   }
                               
                         } else {
                               print ("I could not parse the json dictionary")
                           }
                       }
                   } catch {
                        // error happened
                    }
           })
           task.resume()
        }
    }
}
