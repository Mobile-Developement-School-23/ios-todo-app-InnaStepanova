//
//  HeaderView.swift
//  ToDoList
//
//  Created by Лаванда on 27.06.2023.
//

import UIKit

protocol HeaderViewDelegate {
    func showButtonTapped()
}

class HeaderView: UIView {
    
    var delegate: HeaderViewDelegate!
    var activityIndicator = UIActivityIndicatorView()
    
    private var doneLabel: UILabel = {
        let label = UILabel()
        label.textColor = Resources.Colors.tertiary
        label.font = Resources.Fonts.sfProText400(with: 15)
        label.text = "Выполнено — 5"
        return label
    }()
    
    private var showButton: UIButton = {
        let button = UIButton(type: .system)
//        button.setTitle("Показать", for: .normal)
        button.setTitleColor(Resources.Colors.blueTodo, for: .normal)
        button.setTitleColor(Resources.Colors.tertiary, for: .disabled)
        button.titleLabel?.font = Resources.Fonts.sfProText600(with: 15)
        button.addTarget(self, action: #selector(showButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(doneLabel)
        addSubview(showButton)
        addSubview(activityIndicator)
        backgroundColor = Resources.Colors.primaryBack
        activityIndicator.hidesWhenStopped = true
        doneLabel.translatesAutoresizingMaskIntoConstraints = false
        showButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            showButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            doneLabel.centerYAnchor.constraint(equalTo: showButton.centerYAnchor),
            doneLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            doneLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: showButton.leadingAnchor, constant: -7)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func showButtonPressed() {
        delegate.showButtonTapped()
    }
    
    func setHeader(stateIsDone: Bool, isDoneCount: Int) {
        DispatchQueue.main.async {
            if stateIsDone {
                self.showButton.setTitle("Скрыть", for: .normal)
            } else {
                self.showButton.setTitle("Показать", for: .normal)
            }
            self.doneLabel.text = "Выполнено — \(isDoneCount)"
        }
    }
    
    func stopAnimating() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func startAnimating() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
}
