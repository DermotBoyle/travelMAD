//
//  PersistenceController.swift
//  Weaver_Widget_Demo
//
//  Created by Dermot Boyle on 13/5/23.
//

import Foundation
import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(){
        container = NSPersistentContainer(name: "AllStopsList")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
            
        }
    }
    
    func save (completion: @escaping (Error?) -> () = {_ in}) {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func delete (_ object: NSManagedObject, completion: @escaping (Error?) -> () = {_ in}) {
        let conext = container.viewContext
        conext.delete(object)
        save(completion: completion)
    }
}
