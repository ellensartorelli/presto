//
//  DailyLogReflection.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 4/26/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import Foundation


class DailyLogReflection{
    
    var reflection:String
    var date:Date
    init?(reflection:String, date:Date){
        
        if reflection.isEmpty {
            print("Text is empty)")
            return nil
        }
        self.reflection = reflection
        
        self.date = date
    }
    
    
    
}
