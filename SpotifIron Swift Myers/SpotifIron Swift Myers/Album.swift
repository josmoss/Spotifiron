//
//  Album.swift
//  SpotifIron Swift Myers
//
//  Created by Christopher Myers on 6/17/16.
//  Copyright © 2016 Dragoman Developers, LLC. All rights reserved.
//

import UIKit

class Album: NSObject {

    var href : String = ""
    var albumID : String = ""
    var albumName : String = ""
    var uri : String = ""
    
    override init() {
        super.init()
        
        self.href = ""
        self.albumID = ""
        self.albumName = ""
        self.uri = ""
        
        
    }
    
    
}
