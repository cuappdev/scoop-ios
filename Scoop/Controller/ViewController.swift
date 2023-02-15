//
//  ViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 1/27/22.
//

import SnapKit
import UIKit
import GoogleSignIn

class ViewController: UIViewController {
    
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

            let homeVC = HomeViewController()
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true)
        }
    }
}
