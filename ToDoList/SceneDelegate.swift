//
//  SceneDelegate.swift
//  ToDoList
//
//  Created by Лаванда on 13.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
//        window?.rootViewController = ViewController()
//        window?.rootViewController = UINavigationController(rootViewController: DetailViewController(todoItem: TodoItem(text: " jhgjdshgj ролвполраолв овфоывроарфдлвы форвадлрфлыдлтсв лорыфолрлдврфыдт рифдлорылдрвлдф рофолырлдоврф вфрлоы фврдлырив вфиоывидолф вфдоывлфдытв вфыдлвтиоы вфиолдыив вфыоивдиыф вфоыив вфиодв вдофы дв чытлфдв д  ыфидв фдоыв офыдв дфлвдов дв в двkgkab", importance: .high)))
        window?.rootViewController = UINavigationController(rootViewController: MyTasksViewController())
//        window?.rootViewController = UINavigationController(rootViewController: TodoItemsTableViewController())
    }
}
