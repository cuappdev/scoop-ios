//
//  ImageLabelView.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/9/22.
//

import UIKit

class ImageLabelView: UIView {
    
    let label = UILabel()
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
            make.leading.top.bottom.equalToSuperview()
            make.size.equalTo(25)
        }
    }
    
    private func setupInfoLabel() {
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(imageView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
