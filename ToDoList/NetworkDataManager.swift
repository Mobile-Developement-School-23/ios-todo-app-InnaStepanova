//
//  NetworkDataManager.swift
//  ToDoList
//
//  Created by Лаванда on 04.07.2023.
//

import Foundation

class NetworkDataManager {
    private let networkingService: NetworkingService
    
    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
    }
    
    func fetchDataFromServer() {
        networkingService.fetchData { result in
            switch result {
            case .success(let data):
                print("Success \(data)")
                // Обработка полученных данных
            case .failure(let error):
                print("Error \(error)")
                // Обработка ошибки получения данных
            }
        }
    }
    
    func sendDataToServer(data: Data) {
        networkingService.sendData(data: data) { result in
            switch result {
            case .success:
                print("Success")
                // Успешно отправлено
            case .failure (let error):
                print("Failure \(error)")
                // Обработка ошибки отправки данных
            }
        }
    }
}


extension NetworkDataManager {
    func syncDataWithServer() {
        // Процесс синхронизации с сервером
        
        updateLocalData()
        
        // После успешной синхронизации
        resetIsDirtyFlag()
    }
    
    private func updateLocalData() {
        // Обновление локальных данных после успешной синхронизации
    }
    
    private func resetIsDirtyFlag() {
        // Сброс флага isDirty после успешной синхронизации
    }
}
