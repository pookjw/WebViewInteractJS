//
//  SceneDelegate.swift
//  WebViewInteractJS
//
//  Created by Jinwoo Kim on 9/8/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene: UIWindowScene = (scene as? UIWindowScene) else {
            return
        }
        
        let window: UIWindow = .init(windowScene: windowScene)
        self.window = window
        
        let vc: MyWebViewController = .init()
        let nvc: UINavigationController = .init(rootViewController: vc)
        window.rootViewController = nvc
        window.makeKeyAndVisible()
    }
}
