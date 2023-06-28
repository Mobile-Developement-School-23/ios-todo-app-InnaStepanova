//
//  TodoItemsTableView.swift
//  ToDoList
//
//  Created by Лаванда on 27.06.2023.
//

import UIKit

class TodosTableView: UITableView {
    
    private var todoItems: [TodoItem] = [TodoItem(text: "Купить сыр", importance: .normal),
                                         TodoItem(text: "Сделать пиццу", importance: .low),
                                         TodoItem(id: "1", text: "Задание", importance: .normal, deadline:  Date(), isDone: false, created: Date(), changed: nil),
                                         TodoItem(id: "2", text: "Купить что - то", importance: .high, deadline: nil, isDone: false, created: Date(), changed: nil),
                                         TodoItem(id: "3", text: "Купить что - то", importance: .normal, deadline:  nil, isDone: false, created: Date(), changed: nil),
                                         TodoItem(id: "4", text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно", importance: .normal, deadline:  nil, isDone: false, created: Date(), changed: nil),
                                         TodoItem(id: "5", text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обрезается весь этот текст", importance: .normal, deadline:  nil, isDone: false, created: Date(), changed: nil),
                                         TodoItem(id: "6", text: "Купить что - то", importance: .normal, deadline:  nil, isDone: true, created: Date(), changed: nil),
                                         TodoItem(text: "Проверка", importance: .low)
    ]

    
    // MARK: - Initializers
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = Resources.Colors.secondaryBack
        showsVerticalScrollIndicator = false
        register(TodoTableViewCell.self, forCellReuseIdentifier: "todoCell")
        
        setupTableView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTableView()
    }

    // MARK: - Private methods

    private func setupTableView() {
        delegate = self
        dataSource = self
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension TodosTableView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Implement your own logic
        return todoItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as? TodoTableViewCell else {
            return UITableViewCell()
        }
        let todoItem = todoItems[indexPath.row]
        cell.set(todo: todoItem)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deselectRow(at: indexPath, animated: true)
        let todoItem = todoItems[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.todoItem = todoItem
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = HeaderView()
            return headerView
    }
    
    
//    private func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return CGFloat(10)
//    }

}

