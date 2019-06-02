//
//  CoreDataManager.swift
//  CoreDataProject
//
//  Created by Timur Saidov on 02/06/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    
    // MARK: Public Properties
    
    static let shared = CoreDataManager()
    let privateContextToLoadCourses = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    let mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let privateContextToSaveCourses = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    
    // MARK: Lifecycle
    
    init() {
        privateContextToLoadCourses.parent = mainContext
        mainContext.parent = privateContextToSaveCourses
        privateContextToSaveCourses.persistentStoreCoordinator = CoreDataStack.shared.persistentContainer.persistentStoreCoordinator
    }
    
    
    // MARK: Public
    
    func deleteCourses(completion: @escaping () -> ()) {
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        
        privateContextToLoadCourses.perform { [weak self] in
            guard let self = self else { return }
            
            do {
                let courses = try self.privateContextToLoadCourses.fetch(fetchRequest)
                courses.forEach({ course in
                    self.privateContextToLoadCourses.delete(course)
                })
            } catch {
                print("Can't fetch courses: \(error.localizedDescription)")
            }
            
            do {
                try self.privateContextToLoadCourses.save()
                try self.mainContext.save()
                try self.privateContextToSaveCourses.save()
                
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
