//
//  Habit.swift
//  HabitTracker
//
//  Created by Joy A Wood on 4/26/17.
//  Copyright © 2017 Joy A Wood. All rights reserved.
//

import Foundation

class Habit{
    //MARK: Properties
    var name: String
    var startDate: Date
    var endDate: Date
    var selectedDates: [Date]
    
    
    
    init?(name: String, startDate: Date) {
        guard !name.isEmpty else {
            return nil
        }
        
        //not hundo p sure this is the best way to do this. Experimental
        let minute:TimeInterval = 60.0
        let hour:TimeInterval = 60.0 * minute
        let day:TimeInterval = 24 * hour
        let month:TimeInterval = 31*day
        
        self.name = name
        self.startDate = startDate
        self.endDate = Date(timeInterval: month, since: startDate)
        self.selectedDates = [Date]()
    }
    
    
}
