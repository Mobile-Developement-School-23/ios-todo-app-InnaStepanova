//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Лаванда on 17.06.2023.
//

import UIKit

enum NavBarPosition {
    case left
    case right
}

class DetailViewController: UIViewController {
    
    var todoItem: TodoItem? = DataManader.shared.getData()

    private lazy var textView = TextView(todoItem: todoItem)
    
    private lazy var importanceView = ImportanceView(todoItem: todoItem)
    
    private lazy var deleteButton = DeleteButton(todoItem: todoItem)
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var contentView = UIView()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.axis = .vertical
        return stackView
    }()
    
    private let stackViewDateAndButton: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Resources.Colors.primaryBack
        scrollView.keyboardDismissMode = .interactive
        deleteButton.delegate = self
        textView.delegate = self

        configureNavBar()
        addViews()
        setConstraints()
        addGesture()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        if UIDevice.current.orientation.isLandscape {
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.alignment = .top
            
        } else {
            stackView.axis = .vertical
            stackView.distribution = .fill
            stackView.alignment = .fill
        }

        stackView.layoutIfNeeded()
    }

    
    private func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(stackViewDateAndButton)
        stackViewDateAndButton.addArrangedSubview(importanceView)
        stackViewDateAndButton.addArrangedSubview(deleteButton)
    }
    
    private func setConstraints() {
        
        importanceView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackViewDateAndButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1, constant: -32),
        ])
    }

    private func addGesture() {
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
        let swipeScreen = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeScreen)
    }
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func configureNavBar() {
        title = Resources.Strings.detailTitle
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            .foregroundColor: Resources.Colors.primaryLabel as Any,
            .font: Resources.Fonts.sfProText600(with: 17)]
        addNavBarButton(at: .left, and: Resources.Strings.cancel)
        addNavBarButton(at: .right, and: Resources.Strings.save)
//        ?????  Левая кнопка не активна
//        navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    
    func addNavBarButton(at position: NavBarPosition, and title: String) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(Resources.Colors.blueTodo, for: .normal)
        button.setTitleColor(Resources.Colors.tertiary, for: .disabled)
        
        switch position {
        case .left:
            button.addTarget(self, action: #selector(leftBarButtonPressed), for: .touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
            button.titleLabel?.font = Resources.Fonts.sfProText400(with: 17)
        case .right:
            button.addTarget(self, action: #selector(rightBarButtonPressed), for: .touchUpInside)
            button.titleLabel?.font = Resources.Fonts.sfProText600(with: 17)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
    }
    
    @objc private func leftBarButtonPressed() {
        
    }

    @objc private func rightBarButtonPressed() {
        let newTodo = TodoItem(id: todoItem?.id ?? UUID().uuidString,
                               text: textView.text,
                               importance: importanceView.importance,
                               deadline: importanceView.deadline,
                               isDone: false,
                               created: todoItem?.created ?? Date(),
                               changed: Date())
        
        DataManader.shared.save(todo: newTodo)
    }

}

extension DetailViewController: DeleteButtonDelegate {
    func buttonPressed() {
        if let todoItem = todoItem {
            DataManader.shared.delete(todoItem: todoItem)
        }
    }
}

extension DetailViewController: TextViewDelegate {
    func textNoIsEmpty() {
        navigationItem.rightBarButtonItem?.isEnabled = true
        deleteButton.isEnabled = true
    }
    
    func textIsEmpty() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        deleteButton.isEnabled = false
    }
    
}
