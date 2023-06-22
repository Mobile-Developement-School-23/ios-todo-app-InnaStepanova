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
    func getData() -> TodoItem? {
        let cache = FileCache()
        cache.loadTodoItems(json: "inna")
        return cache.todoItems.first
    }
}
