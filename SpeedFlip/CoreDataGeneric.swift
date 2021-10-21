//
//  GameController.swift
//  MemoryGame
//
//  Created by Nicholas Verrico on 2/25/17.
//  Copyright © 2017 Nicholas Verrico. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class CoreData{
    
       
    // Creates new object in Core Data Stack
    // Returns typecasted object to modify properties
    // Once object properties have been set call contextSave
    func insert<T: NSManagedObject>(entityName:String = T.entityName, entityType:T.Type, context:NSManagedObjectContext? = nil) -> T{
        
        let appDataContext = self.persistentContainer.viewContext
        let objectContext = context ?? appDataContext
        let managedObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: objectContext) as! T
        
        return managedObject
    }
    
    // attempts to save to given context
    // this saves the entire context (usually acceptable), subclass and override if not
    // uses provided errorHandler parameter to handle errors
    // Calls NSLOG for error message if any
    
    func contextSave(context:NSManagedObjectContext? = nil, errorHandler: (()->Void)? = nil) {
        // creates context to app delegate persistence by default
   
        let appDataContext = self.persistentContainer.viewContext
        // override default context with parameter is used
        let objectContext = context ?? appDataContext
        
        // Attempts to save context
        do {try objectContext.save()}
        catch {
            
            errorHandler?()
            
            // error requires typecasting as of Swift version 3.0.2 (swiftlang-800.0.63 clang-800.0.42.1)
            // Dated 25 February, 2017
            NSLog("@%", error as NSError)
        }
    }
    
    // Returns typecasted array of objects or nil if error with fetchRequest
    
    func retrieveAllForEntityType<T:NSManagedObject>(entityName:String = T.entityName, entityType:T.Type, context:NSManagedObjectContext? = nil, returnFetchWithFaults:Bool = false, errorHandler: (()->Void)? = nil) -> [T]?{
        //
      
        let appDataContext = self.persistentContainer.viewContext
        let objectContext = context ?? appDataContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: T.entityName)
        fetchRequest.returnsObjectsAsFaults = returnFetchWithFaults
        
        do {
            let fetchedObjects = try objectContext.fetch(fetchRequest)
            
            // Returns array of acore objects
            return (fetchedObjects as? [T])
            
        } catch{
          errorHandler?()
           
            // error requires typecasting as of Swift version 3.0.2 (swiftlang-800.0.63 clang-800.0.42.1)
            // Dated 25 February, 2017
            NSLog("@%", error as NSError)
        }
        return nil
    }
    
    //MARK: XCode Generated CDS
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Model")
        
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                fatalError("Unresolved error \(error)")
            }
        }
    }

    
}

extension NSManagedObject{
    static var entityName: String { return String(describing: self) }

}






