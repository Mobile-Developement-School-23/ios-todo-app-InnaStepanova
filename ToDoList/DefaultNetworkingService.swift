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
    var revision = 12
    
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
    
    
    func fetchTodoItems(completion: @escaping (Result<(data: Data, response: URLResponse), Error>) -> Void) {
        guard let url = getURL(id: nil) else { return }
        let request = getRequest(method: .get, url: url, revision: revision)
        
        DispatchQueue.global(qos: .userInteractive).async {
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data, let response = response else { return }
                
                completion(.success((data: data, response: response)))
            }.resume()
        }
    }

    
    func addTodoItem(_ todoItem: TodoItem, completion: @escaping (Bool) -> Void) {
        var isSuccess = false
        guard let url = getURL(id: nil) else {return}
        var request = getRequest(method: .post, url: url, revision: revision)
        
        let element = todoItem.jsonBack
        let todoBack: [String : Any] = ["element" : element, "status" : "Ok", "revision" : revision]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: todoBack, options: []) else { return }
        request.httpBody = httpBody
        DispatchQueue.global(qos: .userInteractive).async {
            URLSession.shared.dataTask(with: request) { data , responce, error in
                if let error = error {
                    print(error)
                    return
                }
                if let responce = responce as? HTTPURLResponse {
                    if responce.statusCode == 200 {
                        isSuccess = true
                        
                    }
                    if let data = data {
                        do {
                            let task = try JSONDecoder().decode(TaskBack.self, from: data)
                            self.revision = task.revision
                            
                        } catch {
                            
                        }
                    }
                }
            }.resume()
        }
    completion(isSuccess)
    }
    
    func deleteTodoItem(_ todoItem: TodoItem, completion: @escaping (Bool) -> Void) {
        guard let url = getURL(id: todoItem.id) else {return}
        var isSuccess = false
        let request = getRequest(method: .delete, url: url, revision: revision)
        DispatchQueue.global(qos: .userInteractive).async {
            URLSession.shared.dataTask(with: request) { data, responce, error in
                if let error = error {
                    print(error)
                }
                if let responce = responce as? HTTPURLResponse {
                    if responce.statusCode == 200 {
                        isSuccess = true
                    }
                }
                if let data = data {
                    do {
                        let task = try JSONDecoder().decode(TaskBack.self, from: data)
                        self.revision = task.revision
                        
                    } catch {
                        
                    }
                }

            }.resume()
        }
        completion(isSuccess)
    }
    
    func changeTodoItem(_ todoItem: TodoItem, completion: @escaping (Bool) -> Void) {
        var isSuccess = false
        DispatchQueue.global(qos: .userInteractive).async {
            guard let url = self.getURL(id: todoItem.id) else {return}
            var request = self.getRequest(method: .put, url: url, revision: self.revision)
            
            let element = todoItem.jsonBack
            let todoBack: [String : Any] = ["element" : element, "status" : "Ok", "revision" : self.revision]
            guard let httpBody = try? JSONSerialization.data(withJSONObject: todoBack, options: []) else { return }
            request.httpBody = httpBody
            
            URLSession.shared.dataTask(with: request) { data, responce, error in
                if let error = error {
                    print(error)
                    return
                }
                if let responce = responce as? HTTPURLResponse {
                    if responce.statusCode == 200 {
                        isSuccess = true
                    }
                }
                if let data = data {
                    do {
                        let task = try JSONDecoder().decode(TaskBack.self, from: data)
                        self.revision = task.revision
                        
                    } catch {
                        
                    }
                }

            }.resume()
        }
        completion(isSuccess)
    }
    
    func updateTodoItems(_ todoItems: [TodoItem],completion: @escaping(TasksBack) -> Void) {
        guard let url = getURL(id: nil) else {return}
        var request = getRequest(method: .patch, url: url, revision: revision)
        
        let elements = todoItems.map { $0.jsonBack }
        let todoBack: [String : Any] = ["list" : elements, "status" : "Ok", "revision" : revision]
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
        let request = getRequest(method: .get, url: url, revision: revision)
        
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


