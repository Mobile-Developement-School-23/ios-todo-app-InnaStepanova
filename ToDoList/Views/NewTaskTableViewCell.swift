//
//  NewTaskTableViewCell.swift
//  ToDoList
//
//  Created by Лаванда on 29.06.2023.
//

import UIKit

class NewTaskTableViewCell: UITableViewCell {
    
    let label = UILabel()
    
    let plusImage = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Resources.Colors.secondaryBack
        plusImage.image = UIImage(named: "plusl")
        label.text = "Новое"
        label.font = Resources.Fonts.sfProText400(with: 17)
        label.textColor = Resources.Colors.blueTodo
        addSubview(label)
        addSubview(plusImage)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        plusImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            plusImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            plusImage.heightAnchor.constraint(equalToConstant: 24),
            plusImage.widthAnchor.constraint(equalTo: plusImage.heightAnchor),
            plusImage.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            plusImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            label.leadingAnchor.constraint(equalTo: plusImage.trailingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: plusImage.centerYAnchor)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
