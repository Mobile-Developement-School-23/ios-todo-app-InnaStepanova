//
//  StorageManager.swift
//  ToDoList
//
//  Created by Лаванда on 12.07.2023.
//

import UIKit
import CoreData

class StorageManager {
    
    private var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "core")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var viewContax: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private func transformToTodoItemData(_ todoItem: TodoItem) -> TodoItemData? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "TodoItemData", in: viewContax) else {
            print ("No Entity Description in func Transform")
            return nil
        }
        
        let todoItemData = NSManagedObject(entity: entityDescription, insertInto: viewContax) as! TodoItemData
        todoItemData.id = todoItem.id
        todoItemData.text = todoItem.text
        todoItemData.isDone = todoItem.isDone
        todoItemData.created = todoItem.created
        todoItemData.changed = todoItem.changed
        todoItemData.importance = todoItem.importance.rawValue
        todoItemData.deadline = todoItem.deadline
        
        return todoItemData
    }
    
    func load() -> [TodoItemData] {
        let fetchRequest: NSFetchRequest<TodoItemData> = TodoItemData.fetchRequest()
        do {
            return try viewContax.fetch(fetchRequest)
        } catch {
            print("Failed to fetch data, \(error)")
            return []
        }
    }
    
    func insert(new todoItem: TodoItem) {
        
    }
    
    func edit(_ todoItem: TodoItem) {
        
        saveContex()
    }
    
    func delete(_ todoItem: TodoItem) {
        viewContax.delete(<#T##object: NSManagedObject##NSManagedObject#>)
        saveContex()
    }
    
    func saveContex() {
        if viewContax.hasChanges {
            do {
                try viewContax.save()
            } catch {
             let nsError = error as NSError
            fatalError("Unresolved error \(nsError)")
            }
        }
    }
}
