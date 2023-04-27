//
//  ViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 1/27/22.
//

import GoogleSignIn
import SnapKit
import UIKit

class LoginViewController: UIViewController {
    
    private let backgroundImageView = UIImageView()
    private let greenSignInButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupBackgroundImage()
        setupGreenSignInButton()
    }
    
    private func setupGreenSignInButton() {
        greenSignInButton.setTitle("Login with NetID", for: .normal)
        greenSignInButton.setTitleColor(.white, for: .normal)
        greenSignInButton.backgroundColor = .scoopDarkGreen
        greenSignInButton.layer.cornerRadius = 25
        greenSignInButton.titleLabel?.font = UIFont(name: "SFProDisplay-Bold", size: 16)
        view.addSubview(greenSignInButton)
        
        greenSignInButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(50)
        }
        
        let signInAction = UIAction { action in
            self.signIn()
        }
        
        greenSignInButton.addAction(signInAction, for: .touchUpInside)
    }
    
    private func setupBackgroundImage() {
        backgroundImageView.image = UIImage(named: "loginBackground")
        backgroundImageView.contentMode = .scaleAspectFit
        view.addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    private func signIn() {
        let signInConfig = GIDConfiguration.init(clientID: Keys.googleClientID)
        
        GIDSignIn.sharedInstance.configuration = signInConfig
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else { return }
            
            guard let email = result?.user.profile?.email else { return }
            
            guard email.contains("@cornell.edu") || email == "cornellscoopedapp@gmail.com" else {
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
                    if let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                        scene.didCompleteLogin()
                    }
                case .failure(let error):
                    print("Auth Error in LoginViewController: \(error.localizedDescription)")
                }
            }
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
        NetworkManager.shared.getUser { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case.success(let user):
                NetworkManager.shared.currentUser = user
            case.failure(let error):
                guard let window = UIApplication.shared.windows.first else { return }
                NotificationCenter.default.post(name: NSNotification.Name("didCompleteLogin"), object: nil)
                
                if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                    GIDSignIn.sharedInstance.signOut()
                    strongSelf.presentErrorAlert(title: "Failed to Login", message: "Please make sure you have a stable internet connection and try again later.")
                } else {
                    let onboardingVC = OnboardingContainerViewController()
                    onboardingVC.modalPresentationStyle = .fullScreen
                    window.rootViewController?.present(onboardingVC, animated: false)
                }
                
                print("Error in LoginViewController: \(error.localizedDescription)")
            }
        }
    }
    
}
