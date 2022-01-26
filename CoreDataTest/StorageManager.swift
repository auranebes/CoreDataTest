//
//  StorageManager.swift
//  CoreDataTest
//
//  Created by Arslan Abdullaev on 26.01.2022.
//

import Foundation
import CoreData
import UIKit


class TaskData {
    // MARK: - Singletone
    static let shared = TaskData()
    var tasksList: [Task] = []
    private init() {}
    
    // MARK: - Core Data stack
    
    var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreDataTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Methods
    
    func saveTask(_ name: String, _ view: UITableView) {
        let task = Task(context: persistentContainer.viewContext)
        task.name = name
        tasksList.append(task)
        
        let cellIndex = IndexPath(row: tasksList.count - 1, section: 0)
        view.insertRows(at: [cellIndex], with: .fade)
        
        saveContext()
    }
    
    func fetchData() {
        let fetchRequest = Task.fetchRequest()
        do {
            tasksList = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
    
    func editTask(_ name: String, _ indexPath: IndexPath) {
        let task = tasksList[indexPath.row]
        task.name = name
        saveContext()
    }
}
