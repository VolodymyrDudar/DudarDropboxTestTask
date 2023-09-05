//
//  SceneDelegate.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 31.08.2023.
//

import UIKit
import SwiftyDropbox
import Adjust

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let rootVC = LoginViewController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {  
        guard let winScene = (scene as? UIWindowScene) else { return }
        DropboxClientsManager.setupWithAppKey("9u9bbmfg88zipe9")
         
        let environment = ADJEnvironmentSandbox  //forTest
        let config = ADJConfig(appToken: "appToken", environment: environment)
//        Adjust.appDidLaunch(config)
        
        window = .init(windowScene: winScene)
        window?.makeKeyAndVisible() 
        window?.rootViewController = UINavigationController(rootViewController: rootVC)
        
    }
  
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
    }
     
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        rootVC.presenter?.authorized(url: url)
    }
    
    

}

