//
//  HomeViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 2/23/22.
//

import GoogleSignIn
import UIKit

class HomeViewController: UIViewController {
    
    private let postRideButton = UIButton()
    private let signOutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Scoop"
        
        setupPostRideButton()
        //        setupSignOutButton()
    }
    
    private func setupPostRideButton() {
        postRideButton.setImage(UIImage(systemName: "car", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28)), for: .normal)
        postRideButton.backgroundColor = .systemGray5
        postRideButton.layer.cornerRadius = 35
        view.addSubview(postRideButton)
        
        postRideButton.snp.makeConstraints { make in
            make.size.equalTo(70)
            make.trailing.equalToSuperview().inset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        let postRideAction = UIAction { _ in
//            let postRideLocationVC = PostRideLocationViewController()
//            postRideLocationVC.hidesBottomBarWhenPushed = true
//            postRideLocationVC.navigationItem.title = "Trip Details"
//            self.navigationController?.pushViewController(postRideLocationVC, animated: true)
        }
        
        postRideButton.addAction(postRideAction, for: .touchUpInside)
    }
    
    private func setupSignOutButton() {
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        view.addSubview(signOutButton)
        
        signOutButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let signOutAction = UIAction { _ in
            self.signOut()
        }
        
        signOutButton.addAction(signOutAction, for: .touchUpInside)
    }
    
    private func signOut() {
        GIDSignIn.sharedInstance.signOut()
        dismiss(animated: true)
    }
    
}
