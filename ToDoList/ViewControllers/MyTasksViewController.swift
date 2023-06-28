//
//  MyTasksViewController.swift
//  ToDoList
//
//  Created by Лаванда on 26.06.2023.
//

import UIKit

class MyTasksViewController: UIViewController {

    let todoItemsTableView = TodosTableView()
    
    private var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "plus.circle.fill")?.withTintColor( Resources.Colors.blueTodo!, renderingMode: .alwaysOriginal), for: .normal)
        button.bounds.size.height = 44
        button.bounds.size.width = 44

        return button
    }()

    
    override func viewDidLoad() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = Resources.Strings.myTascks
        view.backgroundColor = Resources.Colors.primaryBack
        addViews()
        setConstraints()
    }
    

    
    private func addViews() {
        view.addSubview(plusButton)
        view.addSubview(todoItemsTableView)
    }
    
    private func setConstraints() {
        todoItemsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            todoItemsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            todoItemsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            todoItemsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            todoItemsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
//            plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            plusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//            plusButton.heightAnchor.constraint(equalToConstant: 44),
//            plusButton.widthAnchor.constraint(equalToConstant: 44)
    }
}

