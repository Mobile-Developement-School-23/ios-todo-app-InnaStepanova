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
    let revision: Int32
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
