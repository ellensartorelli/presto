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
    
    /*
     This function will return an Item, creating if it doesn't exist.
     
     it is following the find-or-create design pattern
     */
//    private func findAuthor(name:String)->Author?{
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
//        request.fetchLimit = 1
//        request.predicate = NSPredicate(format:"text == %@", text)
//        do {
//            let matches = try managedObjectContext.fetch(request)
//            
//            if (matches.count == 0){
//                // can't find the author, make one
//                var author:Author!
//                managedObjectContext.performAndWait {
//                    author = Author(context: self.managedObjectContext)
//                    author.name = name
//                }
//                return author
//            }else{
//                return matches[0] as? Item
//            }
//        }catch{
//            fatalError("Unable to fetch Items")
//        }
//        return nil
//    }
    
    /* Add a new book to the collection */
    func add(text:String, type:String, startDate:Date){
        var item:Item!
        managedObjectContext.performAndWait {
            item = Item(context: self.managedObjectContext)
            item.text = text
            item.type = type
            item.startDate = startDate as NSDate?
            self.saveChanges()
        }
    }
    
    /* Update the fields on an item
     
     We make this a seperate function rather than setting the values directly so that we can use findAuthor and save changes.
     */
    func update(oldItem: Item, text:String, type: String, startDate: Date){
        oldItem.text = text
        oldItem.startDate = startDate as NSDate?
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


