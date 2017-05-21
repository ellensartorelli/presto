//
//  DailyLogTask.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/26/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import Foundation
import os.log


class DailyLogTask: NSObject, NSCoding{
    
    //MARK: - PROPERTIES
    
    var title:String
    var alert:Bool
    var alertTime:Date?
    var completed:Bool
    
    init?(title:String, alert:Bool, alertTime:Date, completed:Bool){
        
        if title.isEmpty {
            print("title is empty)")
            return nil
        }
        self.title = title
        self.alert = alert
        self.alertTime = alertTime
        self.completed = false
    }
    
    //MARK: - Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("DailyLogTasks")
    
    
    //MARK: - TYPES
    struct PropertyKey{
        static let title = "title"
        static let alert = "alert"
        static let alertTime = "alertTime"
        static let completed = "completed"
    }
    
    //MARK: - NScoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(alert, forKey: PropertyKey.alert)
        aCoder.encode(alertTime, forKey: PropertyKey.alertTime)
        aCoder.encode(completed, forKey: PropertyKey.completed)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        // The title, startDate, endDate and notes are required. If we cannot decode those vars, the initializer should fail.
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the title for a Daily Log Task object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let alert = aDecoder.decodeBool(forKey: PropertyKey.alert) as? Bool else  {
            os_log("Unable to decode the alert bool for a Daily Log Task object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let alertTime = aDecoder.decodeObject(forKey: PropertyKey.alertTime) as? Date else {
            os_log("Unable to decode the alert time for a Daily Log Task object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(title: title, alert: alert, alertTime: alertTime, completed: false)
    }
    
}
