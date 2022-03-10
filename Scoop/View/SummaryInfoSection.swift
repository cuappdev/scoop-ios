//
//  PostRideSummaryInfoView.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/9/22.
//

import UIKit

class SummaryInfoSection: UIView {
    
    private let infoLabel = UILabel()
    private let infoImageView = UIImageView()
    
    private var title = ""
    private var image: UIImage?
    
    init(title: String, image: UIImage?) {
        super.init(frame: .zero)
        self.title = title
        self.image = image
        
        setupInfoImageView()
        setupInfoLabel()
    }
    
    private func setupInfoImageView() {
        infoImageView.contentMode = .scaleAspectFit
        infoImageView.image = image
        infoImageView.tintColor = .black
        addSubview(infoImageView)
        
        infoImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.size.equalTo(25)
        }
    }
    
    private func setupInfoLabel() {
        infoLabel.font = .systemFont(ofSize: 18)
        infoLabel.text = title
        infoLabel.textColor = .black
        addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints { make in
            make.leading.equalTo(infoImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(infoLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
