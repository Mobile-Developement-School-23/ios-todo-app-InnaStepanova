//
//  TodoCell.swift
//  TodoListSUI
//
//  Created by Лаванда on 19.07.2023.
//

import SwiftUI

struct TaskRow: View {
    var task: TodoItem
    
    private func getCheckImageName() -> String {
        if task.isDone == true {
            return "on"
        } else if task.importance == .high {
            return "HighPriority"
        } else {
            return "off"
        }
    }
    
    private func getDeadlineText() -> String {
        if let deadline = task.deadline {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM"
            formatter.locale = Locale(identifier: "ru_RU")
            let dateString = formatter.string(from: deadline)
            return dateString
        }
        return ""
    }
    
    private var deadLineContent: some View {
        HStack{
            Image(systemName: "calendar")
            Text("\(getDeadlineText())")
        }
        .foregroundColor(Colors.tertiary)
    }
    
    private var textContent: some View {
        HStack{
            if task.importance != .normal {
                Image(task.importance == .high ? "sign" : "arrov")
            }
            Text(task.text)
                .strikethrough(task.isDone)
                .foregroundColor(task.isDone ? Colors.tertiary : .black)
                .lineLimit(3)
        }
    }


    var body: some View {
        HStack {
            Image(getCheckImageName())
            VStack(alignment: .leading, spacing: 0) {
              textContent
                if task.deadline != nil {
                  deadLineContent
                }
            }
        }
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        TaskRow(task: TodoItem(id: "Id", text: "INNA молодец b hhkdshhjkhbkjfhjkbfkjbdbv  hfjdkjf  hkaf idfh hfk f gfk kjjgfk ihfk hflhbf", importance: .high, deadline: Date(), isDone: false, created: Date(), changed: nil))
    }
}
