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
            
            guard let userID = result?.user.userID,
                  let firstName = result?.user.profile?.givenName,
                  let familyName = result?.user.profile?.familyName,
                  let idtoken = result?.user.idToken?.tokenString else {
                GIDSignIn.sharedInstance.signOut()
                return
            }
            
            NetworkManager.shared.authenticateUser(googleID: userID, email: email, firstName: firstName, lastName: familyName, id_token: idtoken) { result in
                switch result {
                case .success(let user):
                    self.setNetID(email: email)
                    NetworkManager.shared.currentUser.firstName = firstName
                    NetworkManager.shared.currentUser.lastName = familyName
                    NetworkManager.userToken = user.accessToken
                    self.getUser()
                case .failure:
                    print("Unable to Authorize")
                }
            }
            
            guard let window = UIApplication.shared.windows.first else {
                return
            }
            
            NotificationCenter.default.post(name: NSNotification.Name("didCompleteLogin"), object: nil)
            
            let onboardingVC = OnboardingContainerViewController()
            onboardingVC.modalPresentationStyle = .fullScreen
            window.rootViewController?.present(onboardingVC, animated: false)
            
            print("User successfully signed in with Cornell email.")
        }
    }
    
    private func setNetID(email: String) {
        guard let strIndex = email.firstIndex(of: "@") else{
            print("Not a valid Cornell email")
            return
        }
        let index = email.index(strIndex, offsetBy: -1)
        let netID = String(email[...index])
        NetworkManager.shared.currentUser.netid = netID
    }
    
    private func getUser() {
        NetworkManager.shared.getUser { result in
            switch result {
            case.success(let user):
                NetworkManager.shared.currentUser = user
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}
