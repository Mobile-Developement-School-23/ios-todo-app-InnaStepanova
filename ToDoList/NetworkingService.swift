//
//  NetworkingService.swift
//  ToDoList
//
//  Created by Лаванда on 04.07.2023.
//

import UIKit

protocol NetworkingService {
    func fetchTodoItems(completion: @escaping (Result<(data: Data, response: URLResponse), Error>) -> Void)
    func addTodoItem(_ todoItem: TodoItem, completion: @escaping (Bool) -> Void)
    func deleteTodoItem(_ todoItem: TodoItem, completion: @escaping (Bool) -> Void)
    func changeTodoItem(_ todoItem: TodoItem, completion: @escaping (Bool) -> Void)
    func updateTodoItems(_ todoItems: [TodoItem],completion: @escaping (Result<(data: Data, response: URLResponse), Error>) -> Void)
    func getTodoItem(id: String, completion: @escaping(TaskBack) -> Void)
}
