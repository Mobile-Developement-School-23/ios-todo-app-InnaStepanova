//
//  FileCache.swift
//  ToDoList
//
//  Created by Лаванда on 13.06.2023.
//

import Foundation

class FileCache {
    
    private(set) var todoItems: [TodoItem] = []
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
            let todoItems = jsonTodo.compactMap{ TodoItem.parse(json: $0) }
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
        
        let jsonArray = todoItems.map{ $0.json }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray)
            try jsonData.write(to: filePath)
        } catch let jsonError {
            print(jsonError)
        }
    }
    
    func saveCSVTodoItems(to file: String) {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = directory.appendingPathComponent("\(file).csv")
        var csv = "id,text,importance,deadline,isDone,created,changed"
        for item in todoItems {
            csv += item.csv
        }
        
        print (csv)
        do {
            try csv.write(to: filePath, atomically: false, encoding: .utf8)
        }
        catch {
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
                    let todoItems = csvRows.compactMap{ TodoItem.parse(csv: $0) }
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
