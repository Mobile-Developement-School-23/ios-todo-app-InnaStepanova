//
//  TodoItemsList.swift
//  TodoListSUI
//
//  Created by Лаванда on 20.07.2023.
//

import SwiftUI

struct TodoItemsList: View {
    
    @State private var todoItem: TodoItem? = nil
    @State private var todoItems: [TodoItem] = [
        TodoItem(text: "Купить хлеба", importance:  .low),
        TodoItem(id: "87", text: "Add new Task", importance: .low, deadline: Date(), isDone: true, created: Date(), changed: nil),
        TodoItem(id: "jbk", text: "Дело очень важное и срочное", importance: .high, deadline: Date(), isDone: false, created: Date(), changed: nil)
    ]
    @State private var showIsDone = false
    @State private var showDetailScreen = false
    
    private func isDone(todoItem: TodoItem) {
        if let index = todoItems.firstIndex(where: {$0.id == todoItem.id}) {
            todoItems[index].isDone = true
        }
    }
    
    private func delete(todoItem: TodoItem) {
        if let index = todoItems.firstIndex(where: {$0.id == todoItem.id}) {
            todoItems.remove(at: index)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                List {
                    Section(header: HStack {
                        Text("Выполнено - \(todoItems.filter { $0.isDone }.count)")
                            .font(.system(size: 15, weight: .regular, design: .default))
                        
                            .textCase(nil)
                        Spacer()
                        Button {
                            showIsDone.toggle()
                        } label: {
                            Text(showIsDone ? "Скрыть" : "Показать")
                                .textCase(nil)
                        }
                    }.padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    ) {
                        ForEach(showIsDone ? todoItems.filter {!$0.isDone} : todoItems, id: \.id) { task in
                            TaskRow(task: task)
                            
                                .onTapGesture {
                                    self.todoItem = task
                                    self.showDetailScreen = true
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        delete(todoItem: task)
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                                    Button {
                                        
                                    } label: {
                                        Image("info")
                                    }
                                    
                                })
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        isDone(todoItem: task)
                                    } label: {
                                        Image("on2")
                                    }
                                    .tint(Colors.greenTodo)
                                }
                        }
                        Text("Новое")
                            .foregroundColor(Colors.tertiary)
                            .padding(EdgeInsets(top: 10, leading: 32, bottom: 10, trailing: 32))
                            .font(.system(size: 17, weight: .regular, design: .default))
                            .onTapGesture {
                                self.todoItem = nil
                                self.showDetailScreen = true
                            }
                            .navigationTitle("Мои дела")
                    }
                }
                .sheet(isPresented: $showDetailScreen, content: {
                    DetailInfo(todoItem: $todoItem)
                })
                .scrollContentBackground(.hidden)
                .background(Colors.primaryBack)
                Button {
                    self.showDetailScreen = true
                } label: {
                    Image("plusl")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .shadow(radius: 10)
                }
                .sheet(isPresented: $showDetailScreen) {
                    DetailInfo(todoItem: $todoItem)
                }
            }
        }
    }
}

struct TodoItemsList_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemsList()
    }
}

