//
//  FutureLog.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/24/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import Foundation
import os.log

class FutureLogEvent: NSObject, NSCoding{
    
    //MARK: - PROPERTIES
    
    var title:String
    var startDate:Date
    var endDate:Date
    var notes:String
    
    init?(title:String, startDate:Date, endDate:Date, notes:String){
        
        if title.isEmpty {
            print("title is empty)")
            return nil
        }
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.notes = notes
    }
    
    //MARK: - Archiving Paths
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("FutureLogEvents")
    
    
    
    //MARK: - TYPES
    struct PropertyKey{
        static let title = "title"
        static let startDate = "startDate"
        static let endDate = "endDate"
        static let notes = "notes"
    }
    
    //MARK: - NScoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(startDate, forKey: PropertyKey.startDate)
        aCoder.encode(endDate, forKey: PropertyKey.endDate)
        aCoder.encode(notes, forKey: PropertyKey.notes)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        // The title, startDate, endDate and notes are required. If we cannot decode those vars, the initializer should fail.
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else {
            os_log("Unable to decode the title for a Future Log Event object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let startDate = aDecoder.decodeObject(forKey: PropertyKey.startDate) as? Date else {
            os_log("Unable to decode the startDate for a Future Log Event object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let endDate = aDecoder.decodeObject(forKey: PropertyKey.endDate) as? Date else {
            os_log("Unable to decode the endDate for a Future Log Event object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let notes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String else {
            os_log("Unable to decode the notes for a Future Log Event object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(title: title, startDate: startDate, endDate: endDate, notes: notes)
    }
    
    
}
