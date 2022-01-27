//
//  ViewController.swift
//  Rideshare
//
//  Created by Reade Plunkett on 1/27/22.
//

import SnapKit
import UIKit

class ViewController: UIViewController {
    
    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLabel()
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
}
