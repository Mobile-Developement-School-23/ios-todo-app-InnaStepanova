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
    
    let networkingService = DefaultNetworkingService()
    let cache = FileCache()
    var todoItems: [TodoItem] = []
    
    func getData(completion: @escaping ([TodoItem]) -> Void) {
        networkingService.fetchTodoItems { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success((let data, let responce)) :
                print("RESPONCE \(responce)")
                guard let response = responce as? HTTPURLResponse else { return }
                if response.statusCode == 200 {
                    if data != nil {
                        do {
                            let tasks = try JSONDecoder().decode(TasksBack.self, from: data)
                            strongSelf.networkingService.revision = tasks.revision
                            print("РЕВИЗИЯ = \(tasks.revision)")
                            print("ПОЛУЧЕНО \(tasks.list.count) элементов")
                            let todoItems = tasks.list.map { $0.toTodoItem }
                            print("TODOITEMS после DECODE \(todoItems)")
                            completion(todoItems)
                        } catch {
                            print("Не удалось декодировать данные")
                            DispatchQueue.global(qos: .userInteractive).async {
                                strongSelf.cache.loadTodoItems(json: "inna")
                                completion(strongSelf.cache.todoItems)
                            }
                        }
                    } else {
                        DispatchQueue.global(qos: .userInteractive).async {
                            strongSelf.cache.loadTodoItems(json: "inna")
                            completion(strongSelf.cache.todoItems)
                        }
                    }
                }
                
            case .failure(let error) :
                print("ERROR - Данные из сети не были загружены \(error)")
//                Если данные из сетине были загружены берем данные из файла на локальном хранилище
                DispatchQueue.global(qos: .userInteractive).async {
                    strongSelf.cache.loadTodoItems(json: "inna")
                    completion(strongSelf.cache.todoItems)
                }
            }
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
