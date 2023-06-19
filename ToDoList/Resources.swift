//
//  Resources.swift
//  ToDoList
//
//  Created by Лаванда on 19.06.2023.
//

import UIKit

enum Resources {
    enum Fonts {
        static func sfProText400(with size:CGFloat) -> UIFont {
            UIFont(name: "SFProText-Regular", size: size) ?? UIFont()
        }
        static func sfProText600(with size:CGFloat) -> UIFont {
            UIFont(name: "SFProText-Semibold", size: size) ?? UIFont()
        }
        static func sfProDisplay600(with size:CGFloat) -> UIFont {
            UIFont(name: "SFProDisplay-Semibold", size: size) ?? UIFont()
        }
        static func sfProDisplay700(with size:CGFloat) -> UIFont {
            UIFont(name: "SFProDisplay-Bold", size: size) ?? UIFont()
        }

    }
    
    enum Colors {
        static let seporator = UIColor(named: "seporator")
        static let blueTodo = UIColor(named: "blueTodo")
        static let disable = UIColor(named: "disable")
        static let elevated = UIColor(named: "elevated")
        static let grayTodo = UIColor(named: "grayTodo")
        static let grayLightTodo = UIColor(named: "grayLightTodo")
        static let greenTodo = UIColor(named: "greenTodo")
        static let iosPrimary = UIColor(named: "iosPrimary")
        static let navBarBlur = UIColor(named: "navBarBlur")
        static let overlay = UIColor(named: "overlay")
        static let primaryBack = UIColor(named: "primaryBack")
        static let primaryLabel = UIColor(named: "primaryLabel")
        static let redTodo = UIColor(named: "redTodo")
        static let secondaryBack = UIColor(named: "secondaryBack")
        static let secondaryLabel = UIColor(named: "secondaryLabel")
        static let tertiary = UIColor(named: "tertiary")
    }
    
    enum Strings {
        static let detailTitle = "Дело"
        static let cancel = "Отменить"
        static let save = "Сохранить"
        static let importance = "Важность"
        static let doBefore = "Сделать до"
        static let delete = "Удалить"
    }
}



