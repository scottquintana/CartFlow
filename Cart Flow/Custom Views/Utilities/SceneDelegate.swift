//
//  SceneDelegate.swift
//  Cart Flow
//
//  Created by Scott Quintana on 8/3/20.
//  Copyright © 2020 Scott Quintana. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var navigationController: UINavigationController?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: ListSelectVC())
        configureNavigationBar()
        window?.makeKeyAndVisible()
    }


    func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {
     
    }


}

