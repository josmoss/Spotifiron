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
    
    var albumArray = [Album]()
    
    var theArtist = Artist()
    

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
        
        return cell
        
    }

    func fetchAlbum(artistID : String) {

        print("fetchAlbum query value is \(artistID)")
        
        let albumURLString = "https://api.spotify.com/v1/search?q=\(theArtist.artistID)&type=album"
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
