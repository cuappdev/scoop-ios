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
        window.rootViewController = LoginViewController()
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
            
            let homeVC = self.createTabBarController()
            homeVC.modalPresentationStyle = .fullScreen
            self.window?.rootViewController?.present(homeVC, animated: true)
            
        }
    }
    
    private func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let homeNavController = UINavigationController(rootViewController: homeViewController)
        homeNavController.navigationBar.prefersLargeTitles = true
        
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        
        let searchNavController = UINavigationController(rootViewController: searchViewController)
        searchNavController.navigationBar.prefersLargeTitles = true
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        let profileNavController = UINavigationController(rootViewController: profileViewController)
        profileNavController.navigationBar.prefersLargeTitles = true
        
        tabBarController.setViewControllers([homeNavController, searchNavController, profileNavController], animated: true)
        
        return tabBarController
    }
}
