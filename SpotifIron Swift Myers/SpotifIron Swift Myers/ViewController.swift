//
//  ViewController.swift
//  SpotifIron Swift Myers
//
//  Created by Christopher Myers on 6/16/16.
//  Copyright © 2016 Dragoman Developers, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var textFieldOutlet: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    let session = NSURLSession.sharedSession()
    
    var currentArtist = Artist()
    
    var artistArray = [Artist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //   Do any additional setup after loading the view, typically from a nib.
    }
    // MARK : Grab text and implement parsing method
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if let query = textField.text {
            print("The textfield value is \(query)")
            self.fetchArtist(query)
        }
        return true
    }
    
    // MARK : Table View Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.artistArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView .dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        self.currentArtist = self.artistArray[indexPath.row]
        
        cell.textLabel?.text = currentArtist.name
        
        // begin asynchronous section on converting URL strings into images
        if let imageURL = NSURL(string: self.currentArtist.imageURL) {
            let imageSession = NSURLSession.sharedSession()
            let task = imageSession.dataTaskWithURL(imageURL, completionHandler: {
                (data, response, error) in
                
                if error != nil {
                    print("image error occurred")
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        // make sure the file "No_image" is in the assets folder
                        // I just pulled this from the internet
                        
                        cell.imageView?.image = UIImage(named: "No_image")
                        cell.setNeedsLayout()
                    })
                    return
                }
                
                if let data = data {
                    let image = UIImage(data: data)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        cell.imageView?.image = image
                        cell.setNeedsLayout()
                    })
                    
                } else {
                    print ("No data found")
                }
            })
            task.resume()
        }
        // end asynchronous section on converting URL strings to Images
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.currentArtist = self.artistArray[indexPath.row]
        
        performSegueWithIdentifier("albumSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "albumSegue" {
            
            if let controller = segue.destinationViewController as? AlbumsViewController {
                controller.theArtist = self.currentArtist
            }
        }
    }
    
    // MARK: Parsing Method
    
    func fetchArtist(query : String) {
        
        print("fetchArtist query value is \(query)")
        
        self.artistArray.removeAll()
        
        let artistURLString = "https://api.spotify.com/v1/search?q=\(query)&type=artist"
        
        if let url = NSURL(string: artistURLString)
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
                            
                            if let artistDict = dict["artists"] as? JSONDictionary {
                                
                                if let itemsArray = artistDict["items"] as? JSONArray {
                                    
                                    for itemsDict in itemsArray  {
                                        
                                        print("The item dict == \(itemsDict)")
                                        
                                        let theArtist = Artist()
                                        
                                        if let name = itemsDict["name"] as? String {
                                            theArtist.name = name
        
                                        } else {
                                            print("I could not parse the name")
                                        }
                                        
                                        if let artistID = itemsDict["id"] as? String {
                                            theArtist.artistID = artistID
                                        } else {
                                            print("I could not parse the artistID")
                                        }
                           // MARK: trying to pull image URL out
                                        
                                        if let imagesArray = itemsDict["images"] as? JSONArray {
                                            
                                            if imagesArray.isEmpty == false {
                                                
                                                 let firstImageDict = imagesArray.first
                                                
                                                    if let urlString = firstImageDict?["url"] as? String {
                                                        theArtist.imageURL = urlString
                                                }
                                                
                                            } else {
                                                print("Image not found")
                                            }
                                            
                                        } else {
                                            print("I could not parse images")
                                        }
                          // end parsing images section
                                        
                                       self.artistArray.append(theArtist)
                                    }
                                    
                                    print(self.artistArray.count)
                                    
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.tableView.reloadData()
                                    })
                                    
                                } else {
                                    print("I could not parse the items")
                                }
                            } else {
                                print ("I could not parse the artists")
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


