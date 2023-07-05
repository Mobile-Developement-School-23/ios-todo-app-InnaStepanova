//
//  NetworkingService.swift
//  ToDoList
//
//  Created by Лаванда on 04.07.2023.
//

import UIKit

protocol NetworkingService {
    func fetchTodoItems (completion: @escaping(TasksBack) -> Void)
    func addTodoItem(_ todoItem: TodoItem)
    func deleteTodoItem(_ todoItem: TodoItem)
    func changeTodoItem(_ todoItem: TodoItem)
    func updateTodoItems(_ todoItems: [TodoItem],completion: @escaping(TasksBack) -> Void)
    func getTodoItem(id: String, completion: @escaping(TaskBack) -> Void)
}
