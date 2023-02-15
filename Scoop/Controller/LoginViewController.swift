//
//  ViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 1/27/22.
//

import SnapKit
import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    private let label = UILabel()
    private let signInButton = GIDSignInButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLabel()
        setupGoogleSignInButton()
    }
    
    private func setupLabel() {
        label.font = .systemFont(ofSize: 36, weight: .semibold)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.text = "Welcome to Scoop!"
        label.numberOfLines = 0
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupGoogleSignInButton() {
        signInButton.style = .wide
        view.addSubview(signInButton)
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        
        let signInAction = UIAction { action in
            self.signIn()
        }
        
        signInButton.addAction(signInAction, for: .touchUpInside)
    }
    
    private func signIn() {
        let signInConfig = GIDConfiguration.init(clientID: Keys.googleClientID)
        
        GIDSignIn.sharedInstance.configuration = signInConfig
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else { return }
            
            guard let email = result?.user.profile?.email else { return }
            
            guard email.contains("@cornell.edu") else {
                GIDSignIn.sharedInstance.signOut()
                print("User is not a cornell student")
                return
            }
            
            guard let window = UIApplication.shared.windows.first else {
                return
            }
            
            NotificationCenter.default.post(name: NSNotification.Name("didCompleteLogin"), object: nil)
            
            let onboardingVC = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            onboardingVC.modalPresentationStyle = .fullScreen
            window.rootViewController?.present(onboardingVC, animated: false)
            
            print("User successfully signed in with Cornell email.")
        }
    }
}
