//
//  SceneDelegate.swift
//  Scoop
//
//  Created by Reade Plunkett on 1/27/22.
//

import GoogleSignIn
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        window.rootViewController = ViewController()
        self.window = window
        window.makeKeyAndVisible()
        
        restoreSignIn()
        
    }
    
    private func restoreSignIn() {
        guard GIDSignIn.sharedInstance.hasPreviousSignIn() else {
            return
        }
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let user = user else {
                return
            }
            
            let homeVC = HomeViewController()
            homeVC.modalPresentationStyle = .fullScreen
            self.window?.rootViewController?.present(homeVC, animated: true)
            
        }
    }

}
