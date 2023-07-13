//
//  FileCache.swift
//  ToDoList
//
//  Created by Лаванда on 13.06.2023.
import Foundation
import CoreData

class FileCache {
    private(set) var todoItems: [TodoItem] = []
    private(set) var todoItemsData: [TodoItemData] = []
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoItemData")
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
}
// MARK: - Work with CoreData
extension FileCache {
    
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
    
    func load() -> [TodoItem] {
        let fetchRequest: NSFetchRequest<TodoItemData> = TodoItemData.fetchRequest()
        do {
            let todoItemsData = try viewContax.fetch(fetchRequest)
            let todoItems = todoItemsData.compactMap { TodoItem.transform(todoItemData: $0)}
            self.todoItemsData = todoItemsData
            return todoItems
        } catch {
            print("Failed to fetch data, \(error)")
            return []
        }
    }
    
    func insert(_ todoItem: TodoItem) {
        if let entityDescription = NSEntityDescription.entity(forEntityName: "TodoItemData", in: viewContax) {
            let todoItemData = NSManagedObject(entity: entityDescription, insertInto: viewContax) as! TodoItemData
            todoItemData.id = todoItem.id
            todoItemData.text = todoItem.text
            todoItemData.isDone = todoItem.isDone
            todoItemData.created = todoItem.created
            todoItemData.changed = todoItem.changed
            todoItemData.importance = todoItem.importance.rawValue
            todoItemData.deadline = todoItem.deadline
            self.todoItemsData.append(todoItemData)
            saveContex()
        }
    }
    
    func edit(with todoItem: TodoItem) {
        if let todoItemData = getTodoItemData(todoItem) {
            todoItemData.text = todoItem.text
            todoItemData.isDone = todoItem.isDone
            todoItemData.created = todoItem.created
            todoItemData.changed = todoItem.changed
            todoItemData.importance = todoItem.importance.rawValue
            todoItemData.deadline = todoItem.deadline
            saveContex()
        } else {
            insert(todoItem)
        }
    }

    
    func delete(_ todoItem: TodoItem) {
        if let todoItemData = getTodoItemData(todoItem) {
            self.todoItemsData.remove(at: todoItemsData.firstIndex(where: { $0.id == todoItemData.id })!)
            viewContax.delete(todoItemData)
            saveContex()
        }
    }
    
    private func getTodoItemData(_ todoItem: TodoItem) -> TodoItemData? {
        if let todoItemsData = todoItemsData.first(where: { $0.id == todoItem.id }) {
            return todoItemsData
        } else {
            return nil
        }
    }
}

// MARK: - Work with file
extension FileCache {
    func add(todoItem: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == todoItem.id }) {
            todoItems[index] = todoItem
        } else {
            todoItems.append(todoItem)
        }
    }

    func delete(id: String) {
        todoItems.removeAll(where: { $0.id == id })
    }

    func loadTodoItems(json: String) -> [TodoItem] {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = directory.appendingPathComponent("\(json)")

        do {
            let data = try Data(contentsOf: filePath)
            let json = try JSONSerialization.jsonObject(with: data)
            guard let jsonTodo = json as? [Any] else { return [] }
            let todoItems = jsonTodo.compactMap { TodoItem.parse(json: $0) }
            self.todoItems = todoItems
            return todoItems
        } catch let error {
            print(error)
            return []
        }
    }

    func saveTodoItems(to file: String) {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = directory.appendingPathComponent("\(file)")

        let jsonArray = todoItems.map { $0.json }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray)
            try jsonData.write(to: filePath)
        } catch let jsonError {
            print(jsonError)
        }
    }

}

// MARK: - Work with CSV file
extension FileCache {
    
    func saveCSVTodoItems(to file: String) {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = directory.appendingPathComponent("\(file).csv")
        var csv = "id,text,importance,deadline,isDone,created,changed"
        for item in todoItems {
            csv += item.csv
        }

        print(csv)
        do {
            try csv.write(to: filePath, atomically: false, encoding: .utf8)
        } catch {
            print(error)
        }

    }

    func loadTodoItemsFrom(CSV file: String) {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = directory.appendingPathComponent("\(file).csv")

        do {
            let data = try Data(contentsOf: filePath)
            if let csv = String(data: data, encoding: .utf8) {
                var csvRows = csv.components(separatedBy: "\n")
                if csvRows.count <= 1 {
                    todoItems = []
                    print("Файл CSV не содержит данных")
                    return
                }

                let headers = csvRows[0].components(separatedBy: ",")
                if headers.count == 7,
                   headers[0] == "id",
                   headers[1] == "text",
                   headers[2] == "importance",
                   headers[3] == "deadline",
                   headers[4] == "isDone",
                   headers[5] == "created",
                   headers[6] == "changed" {
                    csvRows.removeFirst()
                    print(csvRows.count)
                    let todoItems = csvRows.compactMap { TodoItem.parse(csv: $0) }
                    self.todoItems = todoItems
                }
            } else {
                print("Cannot convert data to string")
            }
        } catch let error {
            print(error)
        }
    }
}
