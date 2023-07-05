//
//  DefaultNetworkingService.swift
//  ToDoList
//
//  Created by Лаванда on 04.07.2023.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
    case patch = "PATCH"
}

class DefaultNetworkingService {
    
    let urlString = Resources.Strings.baseURL
    let revizion = 11
    
    func getURL(id: String?) -> URL? {
        if let id = id {
            guard let url = URL(string: ("\(Resources.Strings.baseURL)/\(id)")) else { return nil}
            return url
        } else {
            guard let url = URL(string: Resources.Strings.baseURL) else { return nil}
            return url
        }
    }
    
    func getRequest(method: HTTPMethod, url: URL, revision: Int) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("Bearer nudophobia", forHTTPHeaderField: "Authorization")
        request.addValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")

        switch method {
        case .get:
            break
        case .post:
            request.httpMethod = HTTPMethod.post.rawValue
        case .delete:
            request.httpMethod = HTTPMethod.delete.rawValue
        case .put:
            request.httpMethod = HTTPMethod.put.rawValue
        case .patch:
            request.httpMethod = HTTPMethod.patch.rawValue
        }
        return request
    }
    
}

extension DefaultNetworkingService: NetworkingService {
        
    func fetchTodoItems (completion: @escaping(TasksBack) -> Void) {
        guard let url = getURL(id: nil) else {return}
        let request = getRequest(method: .get, url: url, revision: revizion)
        
        URLSession.shared.dataTask(with: request) { data, responce, error in
            if let error = error {
                print("URLSession error \(error)")
                return
            }
                
            guard let data = data, let responce = responce else {return}
                do {
                    if let responce = responce as? HTTPURLResponse {
                        print("Status code: \(responce.statusCode)")
                    }
        
                    let todoItems = try JSONDecoder().decode(TasksBack.self, from: data)
                    completion(todoItems)
                    } catch let error {
                        print("Parse JSON Error \(error)")
            }
        }.resume()
    }
    
    func addTodoItem(_ todoItem: TodoItem) {
        guard let url = getURL(id: nil) else {return}
        var request = getRequest(method: .post, url: url, revision: revizion)
        
        let element = todoItem.jsonBack
        let todoBack: [String : Any] = ["element" : element, "status" : "Ok", "revision" : revizion]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: todoBack, options: []) else { return }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { _, responce, error in
            if let error = error {
                print(error)
                return
            }
            if let responce = responce as? HTTPURLResponse {
                print("Status code: \(responce.statusCode)")
            }
        }.resume()
    }
    
    func deleteTodoItem(_ todoItem: TodoItem) {
        guard let url = getURL(id: todoItem.id) else {return}
        var request = getRequest(method: .delete, url: url, revision: revizion)
        
        URLSession.shared.dataTask(with: request) { data, responce, error in
            if let error = error {
                print(error)
                return
            }
            if let responce = responce as? HTTPURLResponse {
                print("Status code: \(responce.statusCode)")
            }
        }.resume()
    }
    
    func changeTodoItem(_ todoItem: TodoItem) {
        guard let url = getURL(id: todoItem.id) else {return}
        var request = getRequest(method: .put, url: url, revision: revizion)
        
        let element = todoItem.jsonBack
        let todoBack: [String : Any] = ["element" : element, "status" : "Ok", "revision" : revizion]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: todoBack, options: []) else { return }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, responce, error in
            if let error = error {
                print(error)
                return
            }
            if let responce = responce as? HTTPURLResponse {
                print("Status code: \(responce.statusCode)")
            }
        }.resume()
    }
    
    func updateTodoItems(_ todoItems: [TodoItem],completion: @escaping(TasksBack) -> Void) {
        guard let url = getURL(id: nil) else {return}
        var request = getRequest(method: .patch, url: url, revision: revizion)
        
        let elements = todoItems.map { $0.jsonBack }
        let todoBack: [String : Any] = ["list" : elements, "status" : "Ok", "revision" : revizion]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: todoBack, options: []) else { return }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, responce, error in
            if let error = error {
                print(error)
                return
            }
            guard let data = data, let responce = responce else {return}
                do {
                    if let responce = responce as? HTTPURLResponse {
                        print("Status code: \(responce.statusCode)")
                    }
        
                    let todoItems = try JSONDecoder().decode(TasksBack.self, from: data)
                    completion(todoItems)
                    } catch let error {
                        print("Parse JSON Error \(error)")
            }
        }.resume()
    }
    
    func getTodoItem(id: String, completion: @escaping(TaskBack) -> Void) {
        guard let url = getURL(id: id) else {return}
        let request = getRequest(method: .get, url: url, revision: revizion)
        
        URLSession.shared.dataTask(with: request) { data, responce, error in
            if let error = error {
                print(error)
                return
            }
            if let responce = responce as? HTTPURLResponse {
                print("Status code: \(responce.statusCode)")
            }
            
            guard let data = data else {return}
                do {
                    let todoItem = try JSONDecoder().decode(TaskBack.self, from: data)
                    completion(todoItem)
                    } catch let error {
                        print(error)
            }
        }.resume()
    }

}
