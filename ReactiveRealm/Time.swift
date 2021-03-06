//
//  Time.swift
//  ReactTrial
//
//  Created by David Wong on 8/04/2016.
//  Copyright © 2016 5dayapp. All rights reserved.
//

import Foundation
import RealmSwift

public class Time: Object {
    dynamic var time : NSDate = NSDate()
    dynamic var id : String = NSUUID().UUIDString
    
    override public static func indexedProperties() -> [String] {
        
        return ["time"]
    }
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    
}
