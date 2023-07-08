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
    
    var networkingService = DefaultNetworkingService()
    var cache = FileCache()
    
    private var stateIsDone = false {
        didSet {
            reloadData()
        }
    }
    
    var qtyIsDone: Int {
        var count = 0
        for item in todoItems {
            if item.isDone {
                count += 1
            }
        }
        return count
    }
    
    private var todoItems: [TodoItem] = [] {
        didSet {
            headerView.setHeader(stateIsDone: stateIsDone, isDoneCount: qtyIsDone)
        }
    }
    
    private var isDurty = false {
        didSet {
            if isDurty {
                print("IS DURTY TRUE")
                DispatchQueue.main.async {
                    self.headerView.actityIndicator.startAnimating()
                }
                DispatchQueue.global(qos: .userInteractive).async {
                    for todo in self.todoItems {
                        self.cache.add(todoItem: todo)
                    }
                    self.cache.saveTodoItems(to: "cache")
                    self.networkingService.retryWithExponentialBackoff(delay: 2.0, retries: 0, list: self.todoItems)
                }
            } else {
                DispatchQueue.main.async {
                    self.headerView.actityIndicator.stopAnimating()
                }
            }
        }
    }
    
    let headerView = HeaderView()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        getData { todoItems in
            DispatchQueue.main.async {
                self.todoItems = todoItems
                self.reloadData()
                self.headerView.actityIndicator.stopAnimating()
            }
        }
        networkingService.delegate = self
        delegate = self
        dataSource = self
        backgroundColor = Resources.Colors.primaryBack
        showsVerticalScrollIndicator = false
        register(TodoTableViewCell.self, forCellReuseIdentifier: "todoCell")
        register(NewTaskTableViewCell.self, forCellReuseIdentifier: "newTask")
        headerView.delegate = self
        headerView.setHeader(stateIsDone: stateIsDone, isDoneCount: qtyIsDone)
       
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
        }
        
        func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
            let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (actions) -> UIMenu? in
                let action1 = UIAction(title: "Готово", image: UIImage(named: "on")) { (_) in
                    self.doneTodoItem(at: indexPath)
                }
                let deleteImage = UIImage(systemName: "trash")?.withTintColor(UIColor.red, renderingMode: .alwaysTemplate)
                let action2 = UIAction(title: "Удалить", image: deleteImage) { (_) in
                    self.deleteTodoItem(at: indexPath)
                }
                return UIMenu(title: "Выберете действие", children: [action1, action2])
            }
            
            let filtredTodoItems = stateIsDone ? todoItems : todoItems.filter { $0.isDone == false }
            if indexPath.row < filtredTodoItems.count {
                return configuration
            }
            return nil
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

        func doneTodoItem(at indexPath: IndexPath) {
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
            DispatchQueue.main.async {
                self.headerView.actityIndicator.startAnimating()
            }
            self.networkingService.changeTodoItem(item) { isSuccess in
                if !isSuccess {
                    self.isDurty = true
                }
                DispatchQueue.main.async {
                    self.headerView.actityIndicator.stopAnimating()
                }
            }
        }
        
        func deleteTodoItem(at indexPath: IndexPath) {
            
                let filtredTodoItems = self.stateIsDone ? self.todoItems : self.todoItems.filter { $0.isDone == false }
                let item = filtredTodoItems[indexPath.row]
                if let index = self.todoItems.firstIndex(where: { $0.id == item.id }) {
                    self.todoItems.remove(at: index)
                }
                self.deleteRows(at: [indexPath], with: .automatic)
            
            self.networkingService.deleteTodoItem(item) { isSuccess in
                if !isSuccess {
                    self.isDurty = true
                }
            }
        }
        
        func doneAction(at indexPath: IndexPath) -> UIContextualAction {
            let action = UIContextualAction(style: .normal, title: nil) { (_, _, completion) in
                self.doneTodoItem(at: indexPath)
                completion(true)
                
            }
            action.backgroundColor = Resources.Colors.greenTodo
            let image = UIImage(named: "on2")
            action.image = image
            return action
        }
        
        func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
            let action = UIContextualAction(style: .normal, title: nil) { (_, _, completion) in
            self.deleteTodoItem(at: indexPath)
                completion(true)
                
            }
            action.backgroundColor = Resources.Colors.redTodo
            let image = UIImage(named: "delete")
            action.image = image
            return action
        }
        
        func informationAction(at indexPath: IndexPath) -> UIContextualAction {
            let action = UIContextualAction(style: .normal, title: nil) { (_, _, completion) in
                //        ЧТОТО ЧТО ДЕЛАЕМ ДЛЯ ПОКАЗА ИНФОРМАЦИИ
                completion(true)
                
            }
            action.backgroundColor = Resources.Colors.grayLightTodo
            let image = UIImage(named: "info")
            action.image = image
            return action
        }
        

        func getData(completion: @escaping ([TodoItem]) -> Void) {
            DispatchQueue.main.async {
                self.headerView.actityIndicator.startAnimating()
            }
            networkingService.fetchTodoItems { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case.failure(let error) :
                    print("не удалось получить данные из сети, загрузка данных из файла")
                    DispatchQueue.global(qos: .userInteractive).async {
                        strongSelf.cache.loadTodoItems(json: "cache")
                        completion(strongSelf.cache.todoItems)
                    }
                case .success((let data, let responce)) :
                    print("RESPONCE \(responce)")
                    guard let response = responce as? HTTPURLResponse else { return }
                    if response.statusCode == 200 {
                        if data != nil {
                            do {
                                let tasks = try JSONDecoder().decode(TasksBack.self, from: data)
                                strongSelf.networkingService.revision = tasks.revision
                                let todoItems = tasks.list.map { $0.toTodoItem }
                                print("TODOITEMS после DECODE \(todoItems)")
                                completion(todoItems)
                            } catch {
                                print("Не удалось декодировать данные")
                                DispatchQueue.global(qos: .userInteractive).async {
                                    strongSelf.cache.loadTodoItems(json: "cache")
                                    completion(strongSelf.cache.todoItems)
                                }
                            }
                        }
                    }
                }
            }
        }


    extension TodoItemsTableView: DetailViewControllerDelegate {
        func delete(todoItem: TodoItem) {
            
            self.networkingService.deleteTodoItem(todoItem) { isSuccess in
                if !isSuccess {
                    self.isDurty = true
                }
            }
            
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
                self.networkingService.changeTodoItem(todoItem) { isSucces in
                    if !isSucces {
                        self.isDurty = true
                    }
                }
                
            } else {
                self.todoItems.insert(todoItem, at: 0)
                let cellIndex = IndexPath(row: 0, section: 0)
                insertRows(at: [cellIndex], with: .automatic)
                self.networkingService.addTodoItem(todoItem) { isSuccess in
                    if !isSuccess {
                        self.isDurty = true
                    }
                }
            }
        }
    }

extension TodoItemsTableView: HeaderViewDelegate {
    func showButtonTapped() {
        stateIsDone.toggle()
        headerView.setHeader(stateIsDone: stateIsDone, isDoneCount: qtyIsDone)
    }
}

extension TodoItemsTableView: DefaultNetworkingServiceDelegate {
    func updateData(todoItems: [TodoItem]) {
        DispatchQueue.main.async {
            self.todoItems = todoItems
            self.reloadData()
            self.isDurty = false
        }
    }
}

