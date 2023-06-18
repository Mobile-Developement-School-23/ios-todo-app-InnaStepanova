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
    }
}

