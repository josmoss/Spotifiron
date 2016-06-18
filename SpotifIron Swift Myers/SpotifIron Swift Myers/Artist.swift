//
//  Artist.swift
//  SpotifIron Swift Myers
//
//  Created by Christopher Myers on 6/16/16.
//  Copyright © 2016 Dragoman Developers, LLC. All rights reserved.
//

import UIKit

class Artist: NSObject {

    var href : String = ""
    var artistID : String = ""
    var name : String = ""
    var popularity : Int = 0
    var artistType : String = ""
    var uri : String = ""
    var imageURL : String = ""
    
    override init() {
        super.init()
        
        self.href = ""
        self.artistID = ""
        self.name = ""
        self.popularity = 0
        self.artistType = ""
        self.uri = ""
        self.imageURL = ""
        
    }
}
