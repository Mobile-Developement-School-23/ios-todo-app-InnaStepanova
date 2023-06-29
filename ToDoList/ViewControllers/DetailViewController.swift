//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Лаванда on 17.06.2023.
//

import UIKit

protocol DetailViewControllerDelegate {
    func save(todoItem: TodoItem)
    func delete(todoItem: TodoItem)
}

enum NavBarPosition {
    case left
    case right
}

class DetailViewController: UIViewController {
    
    private var todoItem: TodoItem?
    
    var delegate2: DetailViewControllerDelegate!

    private lazy var textView = UITextView()
    
    private lazy var importanceView = ImportanceView(todoItem: todoItem)
    
    private lazy var deleteButton = DeleteButton(todoItem: todoItem)
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var contentView = UIView()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.axis = .vertical
//        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    init(todoItem: TodoItem?) {
        super.init(nibName: nil, bundle: nil)
        self.todoItem = todoItem
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Resources.Colors.primaryBack
        scrollView.keyboardDismissMode = .interactive
        deleteButton.delegate = self
        setupTextView()
        configureNavBar()
        addViews()
        setConstraints()
        addGesture()
        setupKeyboardObserver()
    }
    
    func setupTextView(){
        
        textView.text = todoItem?.text
        textView.textColor = UIColor.lightGray
        textView.layer.cornerRadius = 16
        textView.backgroundColor = Resources.Colors.secondaryBack
        textView.font = Resources.Fonts.sfProText400(with: 17)
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.isScrollEnabled = false
        textView.keyboardDismissMode = .interactive
        if todoItem != nil {
            textView.text = todoItem?.text
            textView.textColor = Resources.Colors.primaryLabel
        } else {
            textView.text = Resources.Strings.placeholder
            textView.textColor = Resources.Colors.tertiary
        }
    }

    
    private func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(importanceView)
        stackView.addArrangedSubview(deleteButton)
    }
    
    private func setConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        importanceView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            
        ])
    }

    private func addGesture() {
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
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
    }
    
    func setupKeyboardObserver() {

        NotificationCenter.default.addObserver(
            self,selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self,selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        scrollView.contentInset.bottom = keyboardHeight
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
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
        dismiss(animated: true)
    }

    @objc private func rightBarButtonPressed() {
        let newTodo = TodoItem(id: todoItem?.id ?? UUID().uuidString,
                               text: textView.text,
                               importance: importanceView.importance,
                               deadline: importanceView.deadline,
                               isDone: todoItem?.isDone ?? false,
                               created: todoItem?.created ?? Date(),
                               changed: Date())
        
        delegate2.save(todoItem: newTodo)
        dismiss(animated: true)
    }
}

extension DetailViewController: DeleteButtonDelegate {
    func buttonPressed() {
        if let deletetodoItem = todoItem {
            delegate2.delete(todoItem: deletetodoItem)
        } 
        dismiss(animated: true)
    }
}

extension DetailViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == Resources.Strings.placeholder {
            textView.text = ""
            textView.textColor = Resources.Colors.primaryLabel
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            navigationItem.rightBarButtonItem?.isEnabled = false
    //        deleteButton.isEnabled = false
            deleteButton.configuration?.baseBackgroundColor = Resources.Colors.secondaryBack
            deleteButton.configuration?.baseForegroundColor = Resources.Colors.tertiary
        }
        if textView.text.count == 1 {
            navigationItem.rightBarButtonItem?.isEnabled = true
            deleteButton.isEnabled = true
            deleteButton.configuration?.baseBackgroundColor = Resources.Colors.secondaryBack
            deleteButton.configuration?.baseForegroundColor = Resources.Colors.redTodo
        }
    }
}
