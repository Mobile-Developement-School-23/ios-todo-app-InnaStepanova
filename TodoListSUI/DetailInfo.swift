//
//  DetailInfo.swift
//  TodoListSUI
//
//  Created by Лаванда on 21.07.2023.
//

import SwiftUI

struct DetailInfo: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var todoItem: TodoItem?
    
    @State private var currentText: String = "Что надо сделать?"
    @State private var currentImportance: Int = 1
    @State private var isShowDeadline: Bool = false
    @State private var isShowDatePicker: Bool = false
    @State private var selectedDate: Date = .now + 72000
    
    
    private var textViewContent: some View {
        ZStack(alignment: .leading) {
            TextEditor(text: $currentText)
                .frame(height: 120)
                .padding()
                .scrollContentBackground(.hidden)
                .background(RoundedRectangle(cornerRadius: 16).fill(Colors.secondaryBack))
                .padding(.top)
                .foregroundColor(currentText == "Что надо сделать?" ? Colors.tertiary : .primary)
                .onTapGesture {
                    hidePlaceholder()
                }
        }
    }
    
    private func getDeadlineText() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        formatter.locale = Locale(identifier: "ru_RU")
        let dateString = formatter.string(from: selectedDate)
        return dateString
    }
    
    private func hidePlaceholder() {
        if currentText == "Что надо сделать?" {
            currentText = ""
        }
    }
    
    private func set(_ todoItem: TodoItem?) {
        if let todoItem {
            currentText = todoItem.text
            switch todoItem.importance {
            case .low: currentImportance = 0
            case .normal: currentImportance = 1
            case .high: currentImportance = 2
            }
            
            if let deadline = todoItem.deadline {
                isShowDeadline = true
                selectedDate = deadline
            }
        }
    }
    
    //MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Colors.primaryBack.ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        textViewContent
                        VStack(spacing: 16) {
                            HStack {
                                Text("Важность")
                                Spacer()
                                Picker("", selection: $currentImportance) {
                                    Image(uiImage: UIImage(named: "arrov")!)
                                        .tag(0)
                                    Text("нет").bold()
                                        .tag(1)
                                    Image(uiImage: UIImage(named: "sign")!)
                                        .tag(2)
                                }
                                .frame(width: 150, height: 36)
                                .pickerStyle(.segmented)
                            }
                            
                            Divider()
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Сделать до")
                                    if isShowDeadline {
                                        Button {
                                            isShowDatePicker.toggle()
                                        } label: {
                                            Text(getDeadlineText())
                                        }
                                    }
                                }
                                Spacer()
                                Toggle("", isOn: $isShowDeadline)
                            }
                            
                            if isShowDatePicker {
                                Divider()
                                DatePicker("Picker", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .environment(\.locale, Locale.init(identifier: "ru"))
                                    .padding(.top, -8)
                                    .onChange(of: selectedDate) { newValue in
                                        isShowDatePicker = false
                                    }
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Colors.secondaryBack))
                        
                        Button {
                            
                        } label: {
                            Text("Удалить")
                                .foregroundColor(Colors.redTodo)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 17)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Colors.secondaryBack)
                                )
                        }
                        Spacer()
                        
                    }
                    .padding(.horizontal)
                    
                    .navigationTitle("Дело")
                    .navigationBarBackButtonHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Отменить") {
                                dismiss()
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                dismiss()
                            } label: {
                                Text("Сохранить")
                                    .bold()
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            set(todoItem)
        }
    }
}

// MARK: - Preview
struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        DetailInfo(todoItem: .constant(nil))
    }
}

