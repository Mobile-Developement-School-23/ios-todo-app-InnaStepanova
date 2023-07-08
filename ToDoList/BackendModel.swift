//
//  BackendModel.swift
//  ToDoList
//
//  Created by Лаванда on 04.07.2023.
//

import Foundation
struct TasksBack: Codable {
    let status: String
    let list: [TodoItemBack]
    let revision: Int 
}

struct TaskBack: Codable {
    let element: TodoItemBack
    let revision: Int
}

struct TodoItemBack: Codable {
    let id: String
    var text: String
    var importance: String
    var deadline: Int64?
    var done: Bool
    let created_at: Int64
    var changed_at: Int64?
    var last_updated_by: String
}

extension TodoItemBack {
    var toTodoItem: TodoItem {
        
        let importanceTodo: Importance
        switch importance {
        case "low" : importanceTodo = .low
        case "basic" : importanceTodo = .normal
        case "important" : importanceTodo = .high
        default: importanceTodo = .normal
        }
        
        var deadlineTodo: Date? = nil
        if let deadline = deadline {
            deadlineTodo = Date(timeIntervalSince1970: TimeInterval(deadline))
        }
        
        var changeTodo: Date? = nil
        if let change = changed_at {
            changeTodo = Date(timeIntervalSince1970: TimeInterval(change))
        }
        
        return TodoItem(id: id,
                        text: text,
                        importance: importanceTodo,
                        deadline: deadlineTodo,
                        isDone: done,
                        created: Date(timeIntervalSince1970: TimeInterval(created_at)),
                        changed: changeTodo)
        }
}
