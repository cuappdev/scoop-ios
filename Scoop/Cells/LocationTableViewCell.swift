//
//  LocationViewCell.swift
//  Scoop
//
//  Created by Elvis Marcelo on 4/27/22.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    private var locationLabel = UILabel()
    static let reuseIdentifier = "locationCellReuse"
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        locationLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(locationLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(location: String) {
        locationLabel.text = location
    }

    func setupConstraints() {
        let padding: CGFloat = 8
        let labelHeight: CGFloat = 20

        locationLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(padding)
            make.height.equalTo(labelHeight)
        }
    }
    
}
