//
//  FutureLog.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/24/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import Foundation

class FutureLogEvent{
    
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
    
    
}
