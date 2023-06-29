//
//  MyTasksViewController.swift
//  ToDoList
//
//  Created by Лаванда on 26.06.2023.
//

import UIKit

class MyTasksViewController: UIViewController {
    
//    private lazy var myItems: [TodoItem] = [TodoItem(text: "Купить сыр", importance: .normal),
//                                         TodoItem(text: "Сделать пиццу", importance: .low),
//                                         TodoItem(id: "1", text: "Задание", importance: .normal, deadline:  Date(), isDone: false, created: Date(), changed: nil),
//                                         TodoItem(id: "2", text: "Купить что - то", importance: .high, deadline: nil, isDone: false, created: Date(), changed: nil),
//                                         TodoItem(id: "3", text: "Купить что - то", importance: .normal, deadline:  nil, isDone: false, created: Date(), changed: nil),
//                                         TodoItem(id: "4", text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно", importance: .normal, deadline:  nil, isDone: false, created: Date(), changed: nil),
//                                         TodoItem(id: "5", text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается весь этот текст", importance: .normal, deadline:  nil, isDone: false, created: Date(), changed: nil),
//                                         TodoItem(id: "6", text: "Купить что - то", importance: .normal, deadline:  nil, isDone: true, created: Date(), changed: nil),
//                                         TodoItem(text: "Проверка", importance: .low)
//    ]

    private let todoItemsTableView = TodoItemsTableView(frame: .zero, style: .insetGrouped)
    
    private var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "plus.circle.fill")?.withTintColor( Resources.Colors.blueTodo!, renderingMode: .alwaysOriginal), for: .normal)
        button.bounds.size.height = 44
        button.bounds.size.width = 44
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)

        return button
    }()

    
    override func viewDidLoad() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = Resources.Strings.myTascks
        navigationController?.navigationBar.layoutMargins = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
        view.backgroundColor = Resources.Colors.primaryBack
        todoItemsTableView.delegateTITW = self
        addViews()
        setConstraints()
    }
    

    
    private func addViews() {
        view.addSubview(todoItemsTableView)
        view.addSubview(plusButton)
    }
    
    private func setConstraints() {
        todoItemsTableView.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            todoItemsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            todoItemsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            todoItemsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            todoItemsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            plusButton.heightAnchor.constraint(equalToConstant: 44),
            plusButton.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func plusButtonTapped() {
        let detailVC = DetailViewController(todoItem: nil)
        detailVC.delegate2 = todoItemsTableView
        present(UINavigationController(rootViewController: detailVC), animated: true)
    }
}

extension MyTasksViewController: TodoItemsTableViewDelegate {
    func tappedToCell(with todoItem: TodoItem?) {
        let detailVC = DetailViewController(todoItem: todoItem)
        detailVC.delegate2 = todoItemsTableView
        present(UINavigationController(rootViewController: detailVC), animated: true)
    }
}


