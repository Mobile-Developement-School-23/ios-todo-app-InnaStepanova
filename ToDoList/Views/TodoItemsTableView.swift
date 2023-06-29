//
//  TodoItemsTableView.swift
//  ToDoList
//
//  Created by Лаванда on 27.06.2023.
//

import UIKit

protocol TodoItemsTableViewDelegate {
    func tappedToCell(with todoItem: TodoItem?)
}

class TodoItemsTableView: UITableView {

    
    
    var delegateTITW: TodoItemsTableViewDelegate!
//    let detailVC = DetailViewController(todoItem: nil)
    
    private var stateIsDone = false {
        didSet {
            reloadData()
            
        }
    }
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
    
    let headerView = HeaderView()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
        backgroundColor = Resources.Colors.primaryBack
        showsVerticalScrollIndicator = false
        register(TodoTableViewCell.self, forCellReuseIdentifier: "todoCell")
        register(NewTaskTableViewCell.self, forCellReuseIdentifier: "newTask")
        headerView.delegate = self
       
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    extension TodoItemsTableView: UITableViewDelegate, UITableViewDataSource {
        // MARK: - Table view data source
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if stateIsDone {
                return todoItems.count + 1
            } else {
                return todoItems.filter {$0.isDone == false}.count + 1
                
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as? TodoTableViewCell else {
                    return UITableViewCell()
                }
                let filtredTodoItems = stateIsDone ? todoItems : todoItems.filter { $0.isDone == false }
                
            if indexPath.row <= filtredTodoItems.count - 1 {
                let todoItem = filtredTodoItems[indexPath.row]
                
                cell.set(todo: todoItem)
            }
            guard let newCell = tableView.dequeueReusableCell(withIdentifier: "newTask", for: indexPath) as? NewTaskTableViewCell else {
                return UITableViewCell()
            }
           
            return indexPath.row == filtredTodoItems.count ? newCell : cell
            
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            print(indexPath)
            let filtredTodoItems = stateIsDone ? todoItems : todoItems.filter { $0.isDone == false }
            if indexPath.row <= filtredTodoItems.count - 1 {
                let todoItem = filtredTodoItems[indexPath.row]
                delegateTITW.tappedToCell(with: todoItem)
            } else {
                delegateTITW.tappedToCell(with: nil)
            }
            
            //            present(UINavigationController(rootViewController: detailVC), animated: true)
            
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                return headerView
        }
        
        func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let doneAction = doneAction(at: indexPath)
            
            return UISwipeActionsConfiguration(actions: [doneAction])
        }
        
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let infoAction = informationAction(at: indexPath)
            let deleteAction = deleteAction(at: indexPath)
            return UISwipeActionsConfiguration(actions: [deleteAction, infoAction])
        }
        
        private func countIsDoneItems() -> Int {
            var count = 0
            for item in todoItems {
                if item.isDone {
                    count += 1
                }
            }
            return count
        }

        
        
        func doneAction(at indexPath: IndexPath) -> UIContextualAction {
            let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
                let filtredTodoItems = self.stateIsDone ? self.todoItems : self.todoItems.filter { $0.isDone == false }
                var item = filtredTodoItems[indexPath.row]
                item.isDone = true
                if let index = self.todoItems.firstIndex(where: { $0.id == item.id }) {
                    self.todoItems[index] = item
                }
                if self.stateIsDone {
                    self.reloadRows(at: [indexPath], with: .automatic)
                } else {
                    self.deleteRows(at: [indexPath], with: .automatic)
                }
                completion(true)
                
            }
            action.backgroundColor = Resources.Colors.greenTodo
            let image = UIImage(named: "on2")
            action.image = image
            return action
        }
        
        func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
            let action = UIContextualAction(style: .destructive, title: nil) { (action, view, completion) in
                let filtredTodoItems = self.stateIsDone ? self.todoItems : self.todoItems.filter { $0.isDone == false }
                let item = filtredTodoItems[indexPath.row]
                if let index = self.todoItems.firstIndex(where: { $0.id == item.id }) {
                    self.todoItems.remove(at: index)
                }
                self.deleteRows(at: [indexPath], with: .automatic)
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

    extension TodoItemsTableView: DetailViewControllerDelegate {
        func delete(todoItem: TodoItem) {
            let filtredTodoItems = self.stateIsDone ? self.todoItems : self.todoItems.filter { $0.isDone == false }
            if let index = filtredTodoItems.firstIndex(where: { $0.id == todoItem.id }) {
                if let index = self.todoItems.firstIndex(where: { $0.id == todoItem.id }) {
                    self.todoItems.remove(at: index)
                }
                let cellIndex = IndexPath(row: index, section: 0)
                deleteRows(at: [cellIndex], with: .automatic)

            }
        }

        func save(todoItem: TodoItem) {
            let filtredTodoItems = self.stateIsDone ? self.todoItems : self.todoItems.filter { $0.isDone == false }
            if let index = filtredTodoItems.firstIndex(where: { $0.id == todoItem.id }) {
                if let index = self.todoItems.firstIndex(where: { $0.id == todoItem.id }) {
                    self.todoItems[index] = todoItem
                }
                let cellIndex = IndexPath(row: index, section: 0)
                reloadRows(at: [cellIndex], with: .automatic)
            } else {
                self.todoItems.insert(todoItem, at: 0)
                let cellIndex = IndexPath(row: 0, section: 0)
                insertRows(at: [cellIndex], with: .automatic)
            }
        }
    }

extension TodoItemsTableView: HeaderViewDelegate {
    func showButtonTapped() {
        
        stateIsDone.toggle()
        headerView.setHeader(stateIsDone: stateIsDone, isDoneCount: countIsDoneItems())
        reloadData()
        print("RELOAD")
    }
}
