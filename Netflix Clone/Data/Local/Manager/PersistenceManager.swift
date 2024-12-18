//
//  PersistenceManager.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 17.12.2024.
//
import Foundation
import CoreData

struct PersistenceManager {
    static let shared = PersistenceManager()
    
    static var preview: PersistenceManager = {
        let result = PersistenceManager(inMemory: true)
        let viewContext = result.container.viewContext
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = true) {
        container = NSPersistentContainer(name: "NetflixCloneModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
    }
    
    func saveContext(completionHandler: @escaping (Void?,Error?) -> Void) {
        if PersistenceManager.shared.container.viewContext.hasChanges {
            do {
                try PersistenceManager.shared.container.viewContext.save()
                completionHandler((),nil)
            } catch {
                completionHandler(nil,error)
            }
        }
    }
    
    
    func saveContext () {
        let context = PersistenceManager.shared.container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
