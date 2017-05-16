//
//  ItemCollection.swift
//  presto_v0
//
//  Created by Ellen Sartorelli on 5/15/17.
//  Copyright © 2017 Ellen Sartorelli. All rights reserved.
//

import Foundation
import CoreData

class ItemCollection{
    
    var managedObjectContext: NSManagedObjectContext // our in-memory data store and portal to the database
    var persistentContainer: NSPersistentContainer // our database connection
    
    
    /* Initializes our collection by connecting to the database.
     
     The closure is called when the connection has been established.
     */
    init(completionClosure: @escaping ()->()){
        persistentContainer = NSPersistentContainer(name:"presto_v0")
        managedObjectContext = persistentContainer.viewContext
        
        persistentContainer.loadPersistentStores(){ (description, err) in
            if let err = err{
                // should try harder to mkae the connection and not just dump the user
                fatalError("Could not load Core Data: \(err)")
            }
            
            completionClosure()
        }
    }
    
    
    /* Add a new book to the collection */
    func add(text:String, type:String, time:Date, completed:Bool, alert:Bool){
        var item:Item!
        managedObjectContext.performAndWait {
            item = Item(context: self.managedObjectContext)
            item.text = text
            item.type = type
            item.time = time as NSDate?
            item.completed = false //initialize completed as false
            item.alert = false
            self.saveChanges()
        }
    }
    
    /* Update the fields on an item
     
     We make this a seperate function rather than setting the values directly so that we can use findAuthor and save changes.
     */
    func updateTask(oldItem: Item, text:String, time: Date, completed:Bool, alert:Bool){
        oldItem.text = text
        oldItem.time = time as NSDate?
        oldItem.completed = completed
        oldItem.alert = alert
        //won't update type because it cannot change
    
        self.saveChanges()
    }
    
    func updateEvent(oldItem: Item, text:String, time: Date, completed:Bool, alert:Bool){
        oldItem.text = text
        oldItem.time = time as NSDate?
        oldItem.completed = completed
        oldItem.alert = false
        //won't update type because it cannot change
        
        self.saveChanges()
    }
    
    func updateReflection(oldItem: Item, text:String, time: Date, completed:Bool, alert:Bool){
        oldItem.text = text
        oldItem.time = time as NSDate?
        oldItem.completed = false
        oldItem.alert = false
        //won't update type because it cannot change
        
        self.saveChanges()
    }
    
    /*
     Remove an item from the collection
     */
    func delete(_ item: Item){
        managedObjectContext.delete(item)
        self.saveChanges()
    }
    
    
    /*
     Save any changes stored in our moc back to the database.
     */
    func saveChanges () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}


