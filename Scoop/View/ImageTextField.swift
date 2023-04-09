//
//  ImageTextField.swift
//  Scoop
//
//  Created by Richie Sun on 4/7/23.
//

import UIKit

class ImageTextField: UIView {
    
    let textField = ShiftedRightTextField()
    let imageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        
        setupInfoImageView()
        setupInfoLabel()
    }
    
    private func setupInfoImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview()
            make.size.equalTo(20)
        }
    }
    
    private func setupInfoLabel() {
        addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(5)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(imageView)
            make.height.equalTo(56)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

