//
//  ViewController.swift
//  ToDoList
//
//  Created by Лаванда on 13.06.2023.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // Это директория где находится папка Documents в которую сохраняются json и csv
//        print(NSHomeDirectory())
        
        let todo = TodoItem(id: "CB2C9109-9CDB-46CC", text: "ИННА изменила JSON через методы", importance: .high, deadline: Date(), isDone: false, created: Date(), changed: Date())
        let nm = DefaultNetworkingService()
        nm.deleteTodoItem(todo)
        }
}
