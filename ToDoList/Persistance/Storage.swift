//
//  Storage.swift
//  ToDoList
//
//  Created by Лаванда on 13.07.2023.
//

import Foundation

class Storage {
    
    func saveIsDurtyToUserDefaults(value: Bool) {
        UserDefaults.standard.set(value, forKey: "isDurty")
    }

    func getIsDurtyFromUserDefaults() -> Bool {
        return UserDefaults.standard.bool(forKey: "isDurty")
    }
}
