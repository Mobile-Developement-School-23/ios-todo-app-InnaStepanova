//
//  ImportanceView.swift
//  ToDoList
//
//  Created by Лаванда on 19.06.2023.
//

import UIKit

final class ImportanceView: UIView {
    
    let dateFormatter = DateFormatter()
    private var date: Date?
    var deadline: Date? {
        date
    }
    
    var importance: Importance {
        switch importanceSegmentedControl.selectedSegmentIndex {
        case 0: return .low
        case 1: return .normal
        case 2: return .high
        default: return .normal
        }
    }
    
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
    
     var importanceSegmentedControl: UISegmentedControl = {
        let segmentedControll = UISegmentedControl(items: ["", "", ""])
        segmentedControll.translatesAutoresizingMaskIntoConstraints = false
        segmentedControll.selectedSegmentTintColor = Resources.Colors.elevated
        segmentedControll.backgroundColor = Resources.Colors.overlay
        segmentedControll.setImage(UIImage(named: "arrov"), forSegmentAt: 0)
        segmentedControll.setTitle("нет", forSegmentAt: 1)
        segmentedControll.setImage(UIImage(named: "sign"), forSegmentAt: 2)
        segmentedControll.bounds.size.width = 150
        segmentedControll.bounds.size.height = 36
        return segmentedControll
    }()
    
     var dateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Resources.Colors.blueTodo, for: .normal)
        button.titleLabel?.font = Resources.Fonts.sfProText600(with: 13)
        button.isHidden = true
         button.addTarget(self, action: #selector(dateButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var doBeforeSwitch: UISwitch = {
        let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        sw.addTarget(self, action: #selector(switchChanget), for: .touchUpInside)
        return sw
    }()
    
    private lazy var border: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Resources.Colors.seporator
        view.bounds.size.height = 1
        return view
    }()
    
    private lazy var border2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Resources.Colors.seporator
        view.bounds.size.height = 1
        view.isHidden = true
        return view
    }()
    
    private lazy var calenderView: UICalendarView = {
        let calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.isHidden = true
        return calendarView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var stackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 0
        return stackView
    }()
    
    init(todoItem: TodoItem?) {
        super.init(frame: .zero)
        
        switch todoItem?.importance {
        case .low: importanceSegmentedControl.selectedSegmentIndex = 0
        case .normal: importanceSegmentedControl.selectedSegmentIndex = 1
        case .high : importanceSegmentedControl.selectedSegmentIndex = 2
        case .none: break
        }
        dateFormatter.dateFormat = "d MMMM yyyy"
        
        if let deadlineDate = todoItem?.deadline {
            doBeforeSwitch.isOn = true
            dateButton.isHidden = false
            date = deadlineDate
            dateButton.setTitle("\(dateFormatter.string(from: deadlineDate))", for: .normal)
        }
        
            switch todoItem?.importance {
            case .low: importanceSegmentedControl.selectedSegmentIndex = 0
            case .normal: importanceSegmentedControl.selectedSegmentIndex = 1
            case .high: importanceSegmentedControl.selectedSegmentIndex = 2
            case nil: importanceSegmentedControl.selectedSegmentIndex = 1
        }
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calenderView.selectionBehavior = dateSelection
        self.layer.cornerRadius = 16
        self.backgroundColor = Resources.Colors.secondaryBack
        addViews()
        setConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calenderView.selectionBehavior = dateSelection
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
        addSubview(stackView)
        addSubview(stackView2)
        addSubview(importanceSegmentedControl)
        addSubview(doBeforeSwitch)
        addSubview(border)
        stackView.addArrangedSubview(doBeforeLabel)
        stackView.addArrangedSubview(dateButton)
        stackView2.addArrangedSubview(border2)
        stackView2.addArrangedSubview(calenderView)
    }
    
    @objc private func switchChanget(sender: UISwitch) {
        if sender .isOn {
            UIView.animate(withDuration: 0.2, animations: {
                    self.dateButton.isHidden = false
                })
            let today = Date() // текущая дата
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
            dateButton.setTitle("\(dateFormatter.string(from: tomorrow ?? Date()))", for: .normal)
            date = tomorrow
        } else {
            
            UIView.animate(withDuration: 0.2, animations: {
                    self.calenderView.isHidden = true
                    self.border2.isHidden = true
                    self.dateButton.isHidden = true
                    self.calenderView.alpha = 1.0
                })
            date = nil
        }
    }
    
    @objc private func dateButtonPressed() {
        
        var date = date
        if date == nil {
            let today = Date() // текущая дата
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
            date = tomorrow
        }
        
        
        UIView.animate(withDuration: 0.3, animations: {
                self.calenderView.isHidden = false
                self.border2.isHidden = false
                self.calenderView.alpha = 1.0
            })
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
            border2.heightAnchor.constraint(equalToConstant: 1),
            border2.widthAnchor.constraint(equalTo: border.widthAnchor),
            doBeforeSwitch.topAnchor.constraint(equalTo: border.bottomAnchor, constant: 13),
            doBeforeSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: importanceLabel.leadingAnchor),
            stackView.centerYAnchor.constraint(equalTo: doBeforeSwitch.centerYAnchor),
            border2.topAnchor.constraint(equalTo: doBeforeSwitch.bottomAnchor, constant: 12),
            stackView2.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            stackView2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView2.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
extension ImportanceView: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        UIView.animate(withDuration: 0.3, animations: {
                self.calenderView.isHidden = true
                self.border2.isHidden = true
                self.calenderView.alpha = 1.0
            })
        if let date = selection.selectedDate?.date {
            dateButton.setTitle("\(dateFormatter.string(from: date))", for: .normal)
            self.date = date
        }
    }
}
