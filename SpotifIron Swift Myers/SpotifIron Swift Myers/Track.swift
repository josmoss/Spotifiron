//
//  Track.swift
//  SpotifIron Swift Myers
//
//  Created by Christopher Myers on 6/19/16.
//  Copyright © 2016 Dragoman Developers, LLC. All rights reserved.
//

import UIKit

class Track: NSObject {
    
    var name : String = ""
    var trackNumber : Int = 0
    var duration : Int = 0
    
    override init() {
        super.init()
        
        self.name = ""
        self.trackNumber = 0
        self.duration = 0
        
    }

}
