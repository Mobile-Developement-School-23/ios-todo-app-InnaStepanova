//
//  DeleteButton.swift
//  ToDoList
//
//  Created by Лаванда on 22.06.2023.
//

import UIKit

protocol DeleteButtonDelegate: AnyObject {
    func buttonPressed()
}

class DeleteButton: UIButton {

    var delegate: DeleteButtonDelegate!

    init(todoItem: TodoItem?) {
        super.init(frame: .zero)
        configure()
        if todoItem?.text == "" || todoItem?.text == Resources.Strings.placeholder || todoItem == nil {
//            isEnabled = false
            configuration?.baseForegroundColor = Resources.Colors.tertiary
        } else {
            configuration?.baseForegroundColor = Resources.Colors.redTodo
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        configuration = .filled()
        configuration?.title = Resources.Strings.delete
        configuration?.baseBackgroundColor = Resources.Colors.secondaryBack
        titleLabel?.font = Resources.Fonts.sfProText400(with: 30)
        configuration?.contentInsets.top = 17
        configuration?.contentInsets.bottom = 17
        layer.cornerRadius = 16
        addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
    }

    @objc private func deleteButtonPressed() {
        delegate.buttonPressed()
    }
}
