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
    
    private lazy var containerTextView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Resources.Colors.secondaryBack
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.backgroundColor = Resources.Colors.secondaryBack
        textView.font = Resources.Fonts.sfProText400(with: 17)
        textView.text = Resources.Strings.placeholder
        textView.returnKeyType = .done
        textView.textColor = textView.text == Resources.Strings.placeholder ? Resources.Colors.tertiary : Resources.Colors.primaryLabel
        textView.text = todoItem?.text
        
        return textView
    }()
    
    private lazy var importanceView = ImportanceView(todoItem: todoItem)
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.title = Resources.Strings.delete
        button.configuration?.baseBackgroundColor = Resources.Colors.secondaryBack
        button.configuration?.baseForegroundColor = Resources.Colors.tertiary
        button.titleLabel?.font = Resources.Fonts.sfProText400(with: 30)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.contentInsets.top = 17
        button.configuration?.contentInsets.bottom = 17
        button.layer.cornerRadius = 16
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Resources.Colors.primaryBack

        textView.delegate = self
        configureNavBar()
        addViews()
        setConstraints()
    }
    
    private func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(containerTextView)
        contentView.addSubview(importanceView)
        contentView.addSubview(deleteButton)
        containerTextView.addSubview(textView)
    }
    
    private func setConstraints() {
        importanceView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
    
            containerTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            textView.topAnchor.constraint(equalTo: containerTextView.topAnchor, constant: 12),
            textView.leadingAnchor.constraint(equalTo: containerTextView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: containerTextView.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: containerTextView.bottomAnchor, constant: -12),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),

            importanceView.topAnchor.constraint(equalTo: containerTextView.bottomAnchor, constant: 16),
            importanceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            importanceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            deleteButton.topAnchor.constraint(equalTo: importanceView.bottomAnchor, constant: 16),
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -66)
        ])
    }

    
    private func configureNavBar() {
        title = Resources.Strings.detailTitle
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            .foregroundColor: Resources.Colors.primaryLabel as Any,
            .font: Resources.Fonts.sfProText600(with: 17)]
        addNavBarButton(at: .left, and: Resources.Strings.cancel)
        addNavBarButton(at: .right, and: Resources.Strings.save)
//        ?????  Левая кнопка не активна
        navigationController?.navigationItem.leftBarButtonItem?.isEnabled = false
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
        
    }

}

extension DetailViewController : UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == Resources.Strings.placeholder {
            textView.text = ""
            textView.textColor = Resources.Colors.primaryLabel
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
