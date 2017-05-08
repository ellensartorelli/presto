//
//  DailyLogEvent.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/26/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import Foundation
import os.log

class DailyLogEvent: NSObject, NSCoding{
    //MARK: Properties
    var title:String
    var time:Date
    var completed:Bool
    
    init?(title:String, time:Date, completed:Bool){
        
        if title.isEmpty {
            print("title is empty)")
            return nil
        }
        self.title = title
        self.time = time
        self.completed = false
    }
    
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("DailyLogEvents")
    
    //MARK: Types
    
    struct PropertyKey {
        static let title = "title"
        static let time = "time"
        static let completed = "completed"
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(time, forKey: PropertyKey.time)
        aCoder.encode(completed, forKey: PropertyKey.completed)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The title is required. If we cannot decode a title string, the initializer should fail.
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the title for a DLE object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // The time is required. If we cannot decode a time, the initializer should fail.
        guard let time = aDecoder.decodeObject(forKey: PropertyKey.time) as? Date else {
            os_log("Unable to decode the time for a DLE object.", log: OSLog.default, type: .debug)
            return nil
        }
        
//        // The completed boolean is required. If we cannot decode a completed bool, the initializer should fail.
//        guard let completed = aDecoder.decodeObject(forKey: PropertyKey.completed) as? Bool else {
//            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
//            return nil
//        }
        self.init(title: title, time: time, completed: false)
    }
    
}
