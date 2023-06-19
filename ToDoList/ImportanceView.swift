//
//  ImportanceView.swift
//  ToDoList
//
//  Created by Лаванда on 19.06.2023.
//

import UIKit

final class ImportanceView: UIView {
    
    private lazy var importanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Resources.Strings.importance
        label.textColor = Resources.Colors.primaryLabel
        label.font = Resources.Fonts.sfProText400(with: 17)
        return label
    }()
    
    private lazy var doBeforeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Resources.Strings.doBefore
        label.textColor = Resources.Colors.primaryLabel
        label.font = Resources.Fonts.sfProText400(with: 17)
        return label
    }()
    
    private lazy var importanceSegmentedControl: UISegmentedControl = {
        let segmentedControll = UISegmentedControl(items: ["", "", ""])
        segmentedControll.translatesAutoresizingMaskIntoConstraints = false
        segmentedControll.selectedSegmentTintColor = Resources.Colors.elevated
        segmentedControll.backgroundColor = Resources.Colors.overlay
        segmentedControll.setImage(UIImage(named: "arrov"), forSegmentAt: 0)
        segmentedControll.setTitle("нет", forSegmentAt: 1)
        segmentedControll.setImage(UIImage(named: "sign"), forSegmentAt: 2)
        segmentedControll.bounds.size.width = 150
        segmentedControll.bounds.size.height = 36
        segmentedControll.selectedSegmentIndex = 2
        return segmentedControll
    }()
    
    private lazy var dateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("2 июня 2021", for: .normal)
        button.setTitleColor(Resources.Colors.blueTodo, for: .normal)
        button.titleLabel?.font = Resources.Fonts.sfProText600(with: 13)
        button.isHidden = true
        return button
    }()
    
    private lazy var doBeforeSwitch: UISwitch = {
        let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.isSelected = true
        return sw
    }()
    
    private lazy var border: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Resources.Colors.seporator
        view.bounds.size.height = 1
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 16
        self.backgroundColor = Resources.Colors.secondaryBack
        addViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(importanceLabel)
        addSubview(doBeforeLabel)
        addSubview(importanceSegmentedControl)
        addSubview(dateButton)
        addSubview(doBeforeSwitch)
        addSubview(border)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            importanceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            importanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            importanceSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            importanceSegmentedControl.centerYAnchor.constraint(equalTo: importanceLabel.centerYAnchor),
            border.topAnchor.constraint(equalTo: importanceLabel.bottomAnchor, constant: 18),
            border.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            border.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            border.heightAnchor.constraint(equalToConstant: 1),
            border.widthAnchor.constraint(equalToConstant: 100),
            doBeforeLabel.topAnchor.constraint(equalTo: border.bottomAnchor, constant: 17),
            doBeforeLabel.leadingAnchor.constraint(equalTo: importanceLabel.leadingAnchor),
            doBeforeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17),
//            dateButton.topAnchor.constraint(equalTo: doBeforeLabel.bottomAnchor),
//            dateButton.leadingAnchor.constraint(equalTo: importanceLabel.leadingAnchor),
            doBeforeSwitch.centerYAnchor.constraint(equalTo: doBeforeLabel.centerYAnchor),
            doBeforeSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
}
