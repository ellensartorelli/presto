//
//  DailyLogTask.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/26/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import Foundation


class DailyLogTask{
    
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
        self.completed = completed
    }
    
    
}
