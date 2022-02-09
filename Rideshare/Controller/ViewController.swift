//
//  ViewController.swift
//  Rideshare
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
        label.text = "Welcome to Rideshare!"
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
            let signInConfig = GIDConfiguration.init(clientID: Keys.googleClientID)
            
            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
                guard error == nil else { return }
                
                guard let email = user?.profile?.email else { return }
                
                guard email.contains("@cornell.edu") else {
                    GIDSignIn.sharedInstance.signOut()
                    print("User is not a cornell student")
                    return
                }
                
                print("User successfully signed in with Cornell email.")
            }
        }
        
        signInButton.addAction(signInAction, for: .touchUpInside)
    }
}
