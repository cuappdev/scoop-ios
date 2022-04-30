//
//  LocationViewCell.swift
//  Scoop
//
//  Created by Elvis Marcelo on 4/27/22.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    private var LocationLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        LocationLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(LocationLabel)
        setupConstraints()
    }

    func configure(location: String) {
        LocationLabel.text = location
    }

    func setupConstraints() {
        let padding: CGFloat = 8
        let labelHeight: CGFloat = 20

        LocationLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(padding)
            make.height.equalTo(labelHeight)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}