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
        textView.backgroundColor = Resources.Colors.secondaryBack
        textView.font = Resources.Fonts.sfProText400(with: 17)
        textView.textColor = Resources.Colors.primaryLabel
        textView.text = "А потом вкусно позавтракать"
        return textView
    }()
    
    private lazy var importanceView = ImportanceView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Resources.Colors.primaryBack
        configureNavBar()
        addViews()
        setConstraints()
    }
    
    private func addViews() {
        view?.addSubview(containerTextView)
        containerTextView.addSubview(textView)
        view.addSubview(importanceView)
    }
    
    private func setConstraints() {
        importanceView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            containerTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerTextView.heightAnchor.constraint(equalToConstant: 120),
            
            textView.topAnchor.constraint(equalTo: containerTextView.topAnchor, constant: 12),
            textView.leadingAnchor.constraint(equalTo: containerTextView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: containerTextView.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: containerTextView.bottomAnchor, constant: -12),
            
            importanceView.topAnchor.constraint(equalTo: containerTextView.bottomAnchor, constant: 16),
            importanceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            importanceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureNavBar() {
        title = Resources.Strings.detailTitle
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [
            .foregroundColor: Resources.Colors.primaryLabel,
            .font: Resources.Fonts.sfProText600(with: 17)]
        addNavBarButton(at: .left, and: Resources.Strings.cancel)
        addNavBarButton(at: .right, and: Resources.Strings.save)
    }
    
    func addNavBarButton(at position: NavBarPosition, and title: String) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(Resources.Colors.blueTodo, for: .normal)
        button.setTitleColor(Resources.Colors.tertiary, for: .disabled)
        button.titleLabel?.font = Resources.Fonts.sfProText400(with: 17)
        
        switch position {
        case .left:
            button.addTarget(self, action: #selector(leftBarButtonPressed), for: .touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        case .right:
            button.addTarget(self, action: #selector(rightBarButtonPressed), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
    }
    
    @objc private func leftBarButtonPressed() {
        
    }

    @objc private func rightBarButtonPressed() {
        
    }
    

}
