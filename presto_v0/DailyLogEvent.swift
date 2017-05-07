//
//  DailyLogEvent.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/26/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import Foundation

class DailyLogEvent{
    
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
        self.completed = completed
    }
    
    
}
