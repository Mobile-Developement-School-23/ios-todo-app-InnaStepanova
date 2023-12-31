//
//  TodoItem.swift
//  ToDoList
//
//  Created by Лаванда on 13.06.2023.
//

import Foundation

enum Importance: String {
    case low
    case normal
    case high
}

struct TodoItem: Equatable {
    let id: String
    var text: String
    var importance: Importance
    var deadline: Date?
    var isDone: Bool
    let created: Date
    var changed: Date?
    
    init(id: String = UUID().uuidString,
         text: String,
         importance: Importance,
         deadline: Date? = nil,
         isDone: Bool = false,
         created: Date = Date(),
         changed: Date? = nil) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.created = created
        self.changed = changed
    }
}

extension TodoItem {
    var json: Any {
        var dict: [String: Any] = [:]
        dict["id"] = id
        dict["text"] = text
        if importance != .normal {
            dict["importance"] = "\(importance.rawValue)"
        }
        dict["isDone"] = isDone
        dict["created"] = created.timeIntervalSince1970
        if let changedDate = changed {
            dict["changed"] = changedDate.timeIntervalSince1970
        }
        if let deadlineDate = deadline {
            dict["deadline"] = deadlineDate.timeIntervalSince1970
        }
        return dict
    }
    
    var jsonBack: [String: Any] {
        var dict: [String: Any] = [:]
        dict["id"] = id
        dict["text"] = text
        switch importance {
            
        case .low:
            dict["importance"] = importance.rawValue
        case .normal:
            dict["importance"] = "basic"
        case .high:
            dict["importance"] = "important"
        }
        dict["done"] = isDone
        dict["created_at"] = Int(created.timeIntervalSince1970)
        if let changedDate = changed {
            dict["changed_at"] = Int(changedDate.timeIntervalSince1970)
        }
        if let deadlineDate = deadline {
            dict["deadline"] = Int(deadlineDate.timeIntervalSince1970)
        }
        dict["last_updated_by"] = "id device"
        return dict
    }

    static func parse(json: Any) -> TodoItem? {
        guard let dict = json as? [String: Any],
              let id = dict["id"] as? String,
              let text = dict["text"] as? String,
              let isDone = dict["isDone"] as? Bool,
              let createdTimestamp = dict["created"] as? TimeInterval else {
            return nil
        }

        let importanceString = dict["importance"] as? String
        let importance = Importance(rawValue: importanceString ?? "normal") ?? .normal

        let deadlineTimestamp = dict["deadline"] as? TimeInterval
        let deadline = deadlineTimestamp.map({Date(timeIntervalSince1970: $0)})

        let changedTimestamp = dict["changed"] as? TimeInterval
        let changed = changedTimestamp.map({Date(timeIntervalSince1970: $0)})

        return TodoItem(id: id,
                        text: text,
                        importance: importance,
                        deadline: deadline,
                        isDone: isDone,
                        created: Date(timeIntervalSince1970: createdTimestamp),
                        changed: changed)
    }
    
    static func parse(jsonBack: Any) -> TodoItem? {
        guard let dict = jsonBack as? [String: Any],
              let id = dict["id"] as? String,
              let text = dict["text"] as? String,
              let isDone = dict["done"] as? Bool,
              let createdTimestamp = dict["created_at"] as? TimeInterval else {
            return nil
        }

        let importanceString = dict["importance"] as? String
        let importance: Importance
        
        switch importanceString {
        case "low": importance = Importance.low
        case "basic": importance = Importance.normal
        case "important" : importance = Importance.high
        case .none: importance = Importance.normal
        case .some(_): importance = Importance.normal
        }

        let deadlineTimestamp = dict["deadline"] as? TimeInterval
        let deadline = deadlineTimestamp.map({Date(timeIntervalSince1970: $0)})

        let changedTimestamp = dict["changed_at"] as? TimeInterval
        let changed = changedTimestamp.map({Date(timeIntervalSince1970: $0)})

        return TodoItem(id: id,
                        text: text,
                        importance: importance,
                        deadline: deadline,
                        isDone: isDone,
                        created: Date(timeIntervalSince1970: createdTimestamp),
                        changed: changed)
    }

}

extension TodoItem {
    var csv: String {
        var importanceCSV = ""
        var deadlineCSV = ""
        var changedCSV = ""

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"

        if importance != .normal {
            importanceCSV  = importance.rawValue
        }

        if let deadlineDate = deadline {
            deadlineCSV = "\(dateFormatter.string(from: deadlineDate))"
        }

        if let changedDate = changed {
            changedCSV = "\(dateFormatter.string(from: changedDate))"
        }

        let csvItem: String = "\n\(id),\(text),\(importanceCSV),\(deadlineCSV),\(isDone),\(dateFormatter.string(from: created)),\(changedCSV)"

        return csvItem
    }

    static func parse(csv: String) -> TodoItem? {
        let values = csv.components(separatedBy: ",")
            guard values.count == 7 else {
                return nil
            }

            let id = values[0]
            let text = values[1]
            let importance = Importance(rawValue: values[2]) ?? .normal

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"

            let deadline = values[3] != "" ? dateFormatter.date(from: values[3]) : nil
        if values[4] != "true" && values[4] != "false" {
            return nil
        }
        let isDone = values[4] == "true" ? true : false

        guard let created = dateFormatter.date(from: values[5]) else { return nil }
            let changed = values.count == 7 ? dateFormatter.date(from: values[6]) : nil
            return TodoItem(id: id, text: text, importance: importance, deadline: deadline, isDone: isDone, created: created, changed: changed)
        }
}
//: MARK - TodoItem + CoreData
extension TodoItem {
    static func transform(todoItemData: TodoItemData) -> TodoItem {
        let importance = Importance(rawValue: todoItemData.importance!)

        return TodoItem(id: todoItemData.id!,
                        text: todoItemData.text!,
                        importance: importance ?? Importance.normal,
                        deadline: todoItemData.deadline,
                        isDone: todoItemData.isDone,
                        created: todoItemData.created!,
                        changed: todoItemData.changed)
    }
}
