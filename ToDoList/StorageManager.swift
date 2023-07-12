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
    
    private func insert(_ todoItem: TodoItem) {
        if let entityDescription = NSEntityDescription.entity(forEntityName: "TodoItemData", in: viewContax) {
            let todoItemData = NSManagedObject(entity: entityDescription, insertInto: viewContax) as! TodoItemData
            todoItemData.id = todoItem.id
            todoItemData.text = todoItem.text
            todoItemData.isDone = todoItem.isDone
            todoItemData.created = todoItem.created
            todoItemData.changed = todoItem.changed
            todoItemData.importance = todoItem.importance.rawValue
            todoItemData.deadline = todoItem.deadline
            saveContex()
        }
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
    
    func edit(with todoItem: TodoItem) {
        // Создаем запрос сущности, чтобы найти объект по его идентификатору
        let fetchRequest: NSFetchRequest<TodoItemData> = TodoItemData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", todoItem.id)
        
        do {
            // Выполняем запрос и получаем массив найденных объектов
            let fetchedEntities = try viewContax.fetch(fetchRequest)
            
            // Если найден объект, производим необходимые изменения
            if let entity = fetchedEntities.first {
                entity.text = todoItem.text
                entity.isDone = todoItem.isDone
                entity.created = todoItem.created
                entity.changed = todoItem.changed
                entity.importance = todoItem.importance.rawValue
                entity.deadline = todoItem.deadline
                saveContex()
            } else {
                print("Сущность не найдена")
            }
        } catch {
            print("Ошибка при выполнении запроса: \(error)")
        }
    }

    
    func delete(_ todoItem: TodoItem) {
        // Создаем запрос сущности, чтобы найти объект по его идентификатору
        let fetchRequest: NSFetchRequest<TodoItemData> = TodoItemData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", todoItem.id)
        
        do {
            // Выполняем запрос и получаем массив найденных объектов
            let fetchedEntities = try viewContax.fetch(fetchRequest)
            
            // Если найден объект, производим необходимые изменения
            if let entity = fetchedEntities.first {
                viewContax.delete(entity)
               saveContex()
            } else {
                print("Сущность не найдена")
            }
        } catch {
            print("Ошибка при выполнении запроса: \(error)")
        }
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
