//
//  2TodoTableViewCell.swift
//  ToDoList
//
//  Created by Лаванда on 06.07.2023.
//

import UIKit

class TodoTableViewCell2: UITableViewCell {
    
        lazy var attributeString: NSMutableAttributedString = .init(string: todoTextLabel.text ?? "")
        var const: NSLayoutConstraint!
        
        let checkView: UIImageView = {
            let view = UIImageView()
            view.contentMode = .scaleAspectFit
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
            stack.axis = .horizontal
            stack.alignment = .center
            stack.spacing = 2
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
            addSubview(todoHorizontalStack)
            calendarStack.addArrangedSubview(deadlineView)
            calendarStack.addArrangedSubview(deadlineLabel)
            todoVerticalStack.addArrangedSubview(todoTextLabel)
            todoVerticalStack.addArrangedSubview(calendarStack)
            todoHorizontalStack.addArrangedSubview(importanceView)
            todoHorizontalStack.addArrangedSubview(todoVerticalStack)
            addSubview(checkView)
        }
        
        private func setConstraints() {
            checkView.translatesAutoresizingMaskIntoConstraints = false
            todoHorizontalStack.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                checkView.centerYAnchor.constraint(equalTo: centerYAnchor),
                checkView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                
                todoHorizontalStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                todoHorizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
                todoHorizontalStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
                todoHorizontalStack.leadingAnchor.constraint(equalTo: checkView.trailingAnchor, constant: 16),
                
                
                checkView.heightAnchor.constraint(equalToConstant: 24),
                checkView.widthAnchor.constraint(equalToConstant: 24),
                
                importanceView.heightAnchor.constraint(equalToConstant: 20),
                importanceView.widthAnchor.constraint(equalToConstant: 20),
                
                deadlineView.heightAnchor.constraint(equalToConstant: 16),
                deadlineView.widthAnchor.constraint(equalToConstant: 16)
            ])
        }
        
        override func prepareForReuse() {
            calendarStack.isHidden = true
            todoTextLabel.attributedText = NSAttributedString(string: todoTextLabel.text ?? "", attributes: [:])
            todoTextLabel.textColor = Resources.Colors.primaryLabel
            checkView.image = nil
            importanceView.image = nil
            importanceView.isHidden = true

        }
        
        func set(todo: TodoItem) {
            print("SET")
            if let deadline = todo.deadline {
                calendarStack.isHidden = false
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMMM"
                let dateString = formatter.string(from: deadline)
                deadlineLabel.text = dateString
            }
            
            switch todo.importance {
                
            case .low:
                checkView.image = UIImage(named: "off")
                importanceView.isHidden = false
                importanceView.image = UIImage(named: "arrov")
            case .normal:
                importanceView.isHidden = true
                checkView.image = UIImage(named: "off")
            case .high:
                checkView.image = UIImage(named: "HighPriority")
                importanceView.isHidden = false
                importanceView.image = UIImage(named: "sign")
            }
            
            if todo.isDone {
                checkView.image = UIImage(named: "on")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                todoTextLabel.attributedText = attributeString
                todoTextLabel.textColor = Resources.Colors.tertiary

            } else {
                todoTextLabel.attributedText = NSAttributedString(string: todoTextLabel.text ?? "", attributes: [NSAttributedString.Key.strikethroughStyle: 0])
                todoTextLabel.textColor = Resources.Colors.primaryLabel
            }
            todoTextLabel.text = todo.text
        }

    }

