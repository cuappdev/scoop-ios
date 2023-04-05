//
//  HomeTableViewHeader.swift
//  Scoop
//
//  Created by Reade Plunkett on 4/26/22.
//

import UIKit

class HomeTableViewHeader: UIView {
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.font = UIFont(name: "Rambla-Regular", size: 16)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String?) {
        titleLabel.text = title
    }
    
}
