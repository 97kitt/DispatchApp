//
//  Section.swift
//  Dispatch_App
//
//  Created by MooreDev on 9/3/16.
//  Copyright © 2016 MooreDevelopments. All rights reserved.
//

import Foundation

struct Section {
    
    var heading : String
    var items : [String]
    
    init(title: String, objects : [String]) {
        
        heading = title
        items = objects
    }
}

