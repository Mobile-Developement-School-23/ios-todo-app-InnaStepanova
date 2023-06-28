//
//  TodoItemsTableViewController.swift
//  ToDoList
//
//  Created by Лаванда on 28.06.2023.
//

import UIKit

class TodoItemsTableViewController: UITableViewController {
    
//    let tableView = UITableView(frame: view.bounds, style: .insetGrouped)
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = Resources.Strings.myTascks
        view.backgroundColor = Resources.Colors.primaryBack
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "todoCell")
//        tableView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//        tableView.layoutMargins = .init(top: 0.0, left: 16, bottom: 0.0, right: -16)
//        tableView.separatorInset = tableView.layoutMargins

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Implement your own logic
        return todoItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as? TodoTableViewCell else {
            return UITableViewCell()
        }
        let todoItem = todoItems[indexPath.row]
        cell.set(todo: todoItem)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let todoItem = todoItems[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.todoItem = todoItem
        present(UINavigationController(rootViewController: detailVC), animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = HeaderView()
            return headerView
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = doneAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let infoAction = informationAction(at: indexPath)
        let deleteAction = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction, infoAction])
    }
    
    
    func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            var items = self.todoItems[indexPath.row]
            items.isDone = true
            self.todoItems[indexPath.row] = items
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            completion(true)
            
        }
        action.backgroundColor = Resources.Colors.greenTodo
        let image = UIImage(named: "on2")
        action.image = image
        return action
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: nil) { (action, view, completion) in
            self.todoItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
            
        }
        action.backgroundColor = Resources.Colors.redTodo
        let image = UIImage(named: "delete")
        action.image = image
        return action
    }
    
    func informationAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
//        ЧТОТО ЧТО ДЕЛАЕМ ДЛЯ ПОКАЗА ИНФОРМАЦИИ
            completion(true)
            
        }
        action.backgroundColor = Resources.Colors.grayLightTodo
        let image = UIImage(named: "info")
        action.image = image
        return action
    }
    
}
