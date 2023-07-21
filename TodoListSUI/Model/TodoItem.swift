//
//  TodoItem.swift
//  TodoListSUI
//
//  Created by Лаванда on 19.07.2023.
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

