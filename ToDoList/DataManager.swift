//
//  DataManager.swift
//  ToDoList
//
//  Created by Лаванда on 22.06.2023.
//

import UIKit

class DataManader {
    static let shared = DataManader()
    private init() {}

    let cache = FileCache()
    var todoItems: [TodoItem] = []

    func getFirstTodoItem() -> TodoItem? {
        cache.loadTodoItems(json: "inna")
        self.todoItems = cache.todoItems
        return todoItems.first
    }
    
    func getData() -> [TodoItem] {
        cache.loadTodoItems(json: "inna")
        self.todoItems = cache.todoItems
        if todoItems.isEmpty {
            
            let startTodoItems = [TodoItem(text: "Купить сыр", importance: .normal),
                                  TodoItem(text: "Сделать пиццу", importance: .low),
                                  TodoItem(id: "1", text: "Задание", importance: .normal, deadline:  Date(), isDone: false, created: Date(), changed: nil),
                                  TodoItem(id: "2", text: "Купить что - то", importance: .high, deadline: nil, isDone: false, created: Date(), changed: nil),
                                  TodoItem(id: "3", text: "Купить что - то", importance: .normal, deadline:  nil, isDone: false, created: Date(), changed: nil),
                                  TodoItem(id: "4", text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно", importance: .normal, deadline:  nil, isDone: false, created: Date(), changed: nil),
                                  TodoItem(id: "5", text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается весь этот текст", importance: .normal, deadline:  nil, isDone: false, created: Date(), changed: nil),
                                  TodoItem(id: "6", text: "Купить что - то", importance: .normal, deadline:  nil, isDone: true, created: Date(), changed: nil),
                                  TodoItem(text: "Проверка", importance: .low)
                              ]
            self.todoItems = startTodoItems
            cache.saveTodoItems(to: "inna")
            return startTodoItems
        } else {
            return todoItems
        }
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
