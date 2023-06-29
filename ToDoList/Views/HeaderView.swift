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
        backgroundColor = Resources.Colors.primaryBack
        doneLabel.translatesAutoresizingMaskIntoConstraints = false
        showButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            showButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            doneLabel.centerYAnchor.constraint(equalTo: showButton.centerYAnchor),
            doneLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            doneLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func showButtonPressed() {
        delegate.showButtonTapped()
    }
    
    func setHeader(stateIsDone: Bool, isDoneCount: Int) {
        if stateIsDone {
            showButton.setTitle("Скрыть", for: .normal)
        } else {
            showButton.setTitle("Скрыть", for: .normal)
        }
        doneLabel.text = "Выполнено — \(isDoneCount)"
    }
}
