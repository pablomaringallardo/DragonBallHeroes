//
//  SceneDelegate.swift
//  DragonBallHeroes
//
//  Created by Pablo Marín Gallardo on 22/9/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        if LocalDataManager.shared.isUserLogged() {
            window?.rootViewController = HomeTabBarController()
        } else {
            window?.rootViewController = LoginViewController()
        }
        
        window?.makeKeyAndVisible()
    }
}

    


