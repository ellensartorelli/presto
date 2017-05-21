//
//  Habit.swift
//  HabitTracker
//
//  Created by Joy A Wood on 4/26/17.
//  Copyright © 2017 Joy A Wood. All rights reserved.
//

import Foundation
import os.log

class Habit: NSObject, NSCoding{
    
    //MARK: Properties
    var name: String
    var startDate: Date
    var endDate: Date
    var selectedDates: [Date]

    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("habits")
    
    init?(name: String, startDate: Date) {
        guard !name.isEmpty else {
            return nil
        }
        
        let minute:TimeInterval = 60.0
        let hour:TimeInterval = 60.0 * minute
        let day:TimeInterval = 24 * hour
        let month:TimeInterval = 31*day
        
        self.name = name
        self.startDate = startDate
        self.endDate = Date(timeInterval: month, since: Date())
        self.selectedDates = [Date]()
    }
    
    init?(name: String, startDate: Date, endDate: Date, selectedDates: [Date]) {
        guard !name.isEmpty else {
            return nil
        }
        
        let minute:TimeInterval = 60.0
        let hour:TimeInterval = 60.0 * minute
        let day:TimeInterval = 24 * hour
        let month:TimeInterval = 31*day
        

        self.name = name
        self.startDate = startDate
        self.endDate = Date(timeInterval: month, since: Date())
        self.selectedDates = [Date]()
        self.selectedDates.append(contentsOf: selectedDates)
        
        
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(startDate, forKey: PropertyKey.startDate)
        aCoder.encode(endDate, forKey: PropertyKey.endDate)
        aCoder.encode(selectedDates, forKey: PropertyKey.selectedDates)

    }
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let startDate = "startDate"
        static let endDate = "endDate"
        static let selectedDates = "selectedDates"

    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Habit object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let startDate = aDecoder.decodeObject(forKey: PropertyKey.startDate) as? Date
        let endDate = aDecoder.decodeObject(forKey: PropertyKey.endDate) as? Date
        let selectedDates = aDecoder.decodeObject(forKey: PropertyKey.selectedDates) as? [Date]
        // Must call designated initializer.
        self.init(name: name, startDate: startDate!, endDate: endDate!, selectedDates: selectedDates!)
    }

}
