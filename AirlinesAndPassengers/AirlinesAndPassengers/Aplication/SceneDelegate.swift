//
//  SceneDelegate.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 14.9.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScen = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScen)
        window?.makeKeyAndVisible()
        window?.rootViewController = ContainerVС()
    }

}

