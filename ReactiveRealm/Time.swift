//
//  Time.swift
//  ReactTrial
//
//  Created by David Wong on 8/04/2016.
//  Copyright © 2016 5dayapp. All rights reserved.
//

import Foundation
import RealmSwift

class Time: Object {
    dynamic var time : NSDate = NSDate()
    
    override static func indexedProperties() -> [String] {
        return ["time"]
    }
}
