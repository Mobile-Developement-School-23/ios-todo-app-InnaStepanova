//
//  DataManager.swift
//  ToDoList
//
//  Created by Лаванда on 22.06.2023.
//

import UIKit

class DataManader {
    static let shared = DataManader()
    private init(){}
    
    let cache = FileCache()
    var todoItems: [TodoItem] = []
    
    func getData() -> TodoItem? {
        let cache = FileCache()
        cache.loadTodoItems(json: "inna")
        self.todoItems = cache.todoItems
        return cache.todoItems.first
    }
    func delete(todoItem: TodoItem) {
        cache.delete(id: todoItem.id)
        cache.saveTodoItems(to: "inna")
    }
    
    func save(todo: TodoItem) {
        cache.add(todoItem: todo)
        cache.saveTodoItems(to: "inna")
    }
}
