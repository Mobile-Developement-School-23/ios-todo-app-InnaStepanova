//
//  TextView.swift
//  ToDoList
//
//  Created by Лаванда on 22.06.2023.
//

import UIKit

class TextView: UIView {
    
    private var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.backgroundColor = Resources.Colors.secondaryBack
        textView.font = Resources.Fonts.sfProText400(with: 17)
        textView.returnKeyType = .done
        return textView
    }()
    
    init(todoItem: TodoItem?) {
        super .init(frame: .zero)
        textView.delegate = self
        
        backgroundColor = Resources.Colors.secondaryBack
        layer.cornerRadius = 16
        if todoItem != nil {
            textView.text = todoItem?.text
            textView.textColor = Resources.Colors.primaryLabel
        } else {
            textView.text = Resources.Strings.placeholder
            textView.textColor = Resources.Colors.tertiary
        }
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(textView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
        ])
    }
    
}

extension TextView : UITextViewDelegate {
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
