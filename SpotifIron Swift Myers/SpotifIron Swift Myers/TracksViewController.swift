//
//  TracksViewController.swift
//  SpotifIron Swift Myers
//
//  Created by Christopher Myers on 6/19/16.
//  Copyright © 2016 Dragoman Developers, LLC. All rights reserved.
//

import UIKit

class TracksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let session = NSURLSession.sharedSession()
    
    var theAlbum = Album()
    
    var trackArray = [Track]()
    
    var currentTrack = Track()
    
    var songLength = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchTrack(self.theAlbum.albumID)
        
    }
    
    func duration() {
        
        let minutes = self.currentTrack.duration // 60
        
        let seconds = self.currentTrack.duration % 60
        
        self.songLength = "\(minutes) minutes & \(seconds) seconds"
        
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trackArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCellWithIdentifier("trackCell", forIndexPath: indexPath)
        
        self.currentTrack = self.trackArray[indexPath.row]
        
        cell.textLabel?.font = UIFont.preferredFontForTextStyle("Iowan Old Style")
        
        cell.textLabel?.text = self.currentTrack.name
        
        return cell
    }
    
    
    func fetchTrack(albumID : String)
    {
        print ("fetchTrack query ID is \(albumID)")
        
        self.trackArray.removeAll()
        
        let trackURLString = "https://api.spotify.com/v1/albums/\(albumID)/tracks"
        
        if let url = NSURL(string: trackURLString)
        {
            let task = self.session.dataTaskWithURL(url, completionHandler:
                {
                    (data, response, error) in
                    
                    if error != nil {
                        print ("An error occured")
                        return
                    }
                    do {
                        
                        if let data = data {
                            if let dict = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? JSONDictionary {
                                
                                if let itemsArray = dict["items"] as? JSONArray
                                {
                                    for itemsDict in itemsArray {
                                        print("The itemsDict == \(itemsDict)")
                                        
                                        let theTrack = Track()
                                        
                                        if let name = itemsDict["name"] as? String {
                                            theTrack.name = name
                                            
                                        } else {
                                            print("I could not parse the track name")
                                        }
                                        
                                        if let trackNumber = itemsDict["track_number"] as? Int {
                                            theTrack.trackNumber = trackNumber
                                            
                                        } else {
                                            print("I could not parse the track number")
                                        }
                                        
                                        if let songDuration = itemsDict["duration_ms"] as? Int {
                                            theTrack.duration = songDuration
                                        
                                        } else {
                                            print("I could not parse the song duration")
                                        }
                                        self.trackArray.append(theTrack)
                                        
                                    }
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.tableView.reloadData()
                                    })

                                }
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




