//
//  TodoTableViewCell.swift
//  ToDoList
//
//  Created by Лаванда on 26.06.2023.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    lazy var attributedString2: NSMutableAttributedString = .init(string: todoTextLabel.text ?? "")
    
    let checkView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "circle")?.withTintColor(Resources.Colors.seporator!, renderingMode: .alwaysOriginal)
        return view
    }()
    
    let todoTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = Resources.Fonts.sfProText400(with: 17)
        label.textAlignment = .left
        return label
    }()
    
    let importanceView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let deadlineView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "calendar")?.withTintColor(Resources.Colors.tertiary!, renderingMode: .alwaysOriginal)
        return imageView
    }()
    
    let deadlineLabel: UILabel = {
        let label = UILabel()
        label.font = Resources.Fonts.sfProText400(with: 15)
        label.textColor = Resources.Colors.tertiary
        return label
    }()
    
    let calendarStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .center
        stack.isHidden = true
        return stack
    }()
    
    let todoVerticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 0
        return stack
    }()
    
    let todoHorizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.isHidden = true
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 12
        return stack
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        backgroundColor = Resources.Colors.secondaryBack
        addViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addViews() {
        addSubview(calendarStack)
        addSubview(todoVerticalStack)
        addSubview(todoTextLabel)
        calendarStack.addArrangedSubview(deadlineView)
        calendarStack.addArrangedSubview(deadlineLabel)
        todoVerticalStack.addArrangedSubview(todoTextLabel)
        todoVerticalStack.addArrangedSubview(calendarStack)
        addSubview(checkView)
        addSubview(importanceView)
    }
    
    private func setConstraints() {
        checkView.translatesAutoresizingMaskIntoConstraints = false
        todoHorizontalStack.translatesAutoresizingMaskIntoConstraints = false
        todoTextLabel.translatesAutoresizingMaskIntoConstraints = false
        todoVerticalStack.translatesAutoresizingMaskIntoConstraints = false
        calendarStack.translatesAutoresizingMaskIntoConstraints = false
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        deadlineView.translatesAutoresizingMaskIntoConstraints = false
        importanceView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            todoVerticalStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
//            todoVerticalStack.leadingAnchor.constraint(equalTo: importanceView.trailingAnchor, constant: 2),
            todoVerticalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            todoVerticalStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            importanceView.centerYAnchor.constraint(equalTo: centerYAnchor),
            importanceView.leadingAnchor.constraint(equalTo: checkView.trailingAnchor, constant: 12),
            
            
            checkView.heightAnchor.constraint(equalToConstant: 24),
            checkView.widthAnchor.constraint(equalToConstant: 24),
            
            importanceView.heightAnchor.constraint(equalToConstant: 20),
            
            deadlineView.heightAnchor.constraint(equalToConstant: 16),
            deadlineView.widthAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    override func prepareForReuse() {
        todoTextLabel.attributedText = NSAttributedString(string: todoTextLabel.text ?? "", attributes: [NSAttributedString.Key.strikethroughStyle: 0])
        todoTextLabel.textColor = Resources.Colors.primaryLabel
        todoTextLabel.attributedText = attributedString2
    }
    
    func set(todo: TodoItem) {
        todoTextLabel.text = todo.text
        
        if let deadline = todo.deadline {
            calendarStack.isHidden = false
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM"
            let dateString = formatter.string(from: deadline)
            deadlineLabel.text = dateString
            calendarStack.isHidden = false
        }
        
        switch todo.importance {
            
        case .low:
            checkView.image = UIImage(named: "off")
            importanceView.image = UIImage(named: "arrov")
            todoVerticalStack.leadingAnchor.constraint(equalTo: importanceView.trailingAnchor, constant: 2).isActive = true
        case .normal:
            checkView.image = UIImage(named: "off")
            todoVerticalStack.leadingAnchor.constraint(equalTo: checkView.trailingAnchor, constant: 12).isActive = true
            
        case .high:
            checkView.image = UIImage(named: "HighPriority")
            importanceView.image = UIImage(named: "sign")
            todoVerticalStack.leadingAnchor.constraint(equalTo: importanceView.trailingAnchor, constant: 2).isActive = true
        }
        
        if todo.isDone {
            checkView.image = UIImage(named: "on")
            attributedString2.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString2.length))
            todoTextLabel.attributedText = attributedString2
            todoTextLabel.textColor = Resources.Colors.tertiary

        }
        todoTextLabel.text = todo.text
    }

}
