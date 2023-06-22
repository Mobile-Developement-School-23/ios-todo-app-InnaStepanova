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
//   Это директория где находится папка Documents в которую сохраняются json и csv
        print(NSHomeDirectory())
        view.backgroundColor = .red
        
        let todo = TodoItem(text: "Here is the trick that worked for me:Add a ScrollView to your wished ViewController. Select it in the Outline and open its size inspector. Uncheck there the option .Now set leading/top/trailing and bottom constrains to 0 of the ScrollView.Add in a UIView and constrain its leading/top/trailing and bottom also to 0.Add an equal width constrain to the UIView. (The width needs to be equal the width of the view from the ViewController, with this way you are disabeling horizontal scrolling).The warning will disappear if every element inside the UIView is chained vertically. This means, that the top element has a constrain to the top of the view and to the element under it and so on. The last element needs a constrain to the bottom of the view.If you followed this steps you should be fine with ScrollViews. This way you also can add as many content as you want to the bottom and the ScrollView will extend dynamically.I hope I explained it well enough.", importance: .high)
    
        let cache = FileCache()
        cache.add(todoItem: todo)
        print(cache.todoItems)
        cache.saveTodoItems(to: "inna")
        
    }
}

