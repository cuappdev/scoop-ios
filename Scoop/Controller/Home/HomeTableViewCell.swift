//
//  HomeTableViewCell.swift
//  Scoop
//
//  Created by Reade Plunkett on 4/21/22.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    var selectedRide: Ride?
    
    // MARK: Views
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let depatureLabel = ImageLabelView()
    private let arrivalLabel = ImageLabelView()
    private let dateLabel = ImageLabelView()
    private let dotsImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupContainerView()
        setupDateLabel()
        setupTitleLabel()
        setupDepartureLabel()
        setupDotsImageView()
        setupArrivalLabel()
    }
    
    private func setupContainerView() {
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.borderColor.cgColor
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func setupDateLabel() {
        dateLabel.imageView.image = UIImage(systemName: "calendar")
        dateLabel.label.font = .systemFont(ofSize: 16)
        containerView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
        }
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .black
        containerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(10)
            make.trailing.lessThanOrEqualTo(dateLabel.snp.leading).offset(-10)
        }
    }
    
    private func setupDepartureLabel() {
        depatureLabel.imageView.image = UIImage(systemName: "location")
        depatureLabel.label.font = .systemFont(ofSize: 16)
        containerView.addSubview(depatureLabel)
        
        depatureLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
    }
    
    private func setupDotsImageView() {
        dotsImageView.contentMode = .scaleAspectFit
        dotsImageView.image = UIImage(named: "Dots")
        containerView.addSubview(dotsImageView)
        
        dotsImageView.snp.makeConstraints { make in
            make.centerX.equalTo(depatureLabel.imageView)
            make.top.equalTo(depatureLabel.snp.bottom).offset(5)
        }
    }
    
    private func setupArrivalLabel() {
        arrivalLabel.imageView.image = UIImage(systemName: "mappin.and.ellipse")
        arrivalLabel.label.font = .systemFont(ofSize: 16)
        containerView.addSubview(arrivalLabel)
        
        arrivalLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(dotsImageView.snp.bottom).offset(5)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configure(ride: Ride) {
        selectedRide = ride
        dateLabel.label.text = ride.departureDatetime
        titleLabel.text = "\(ride.creator.firstName)'s Ride"
        depatureLabel.label.text = ride.path.startLocationName
        arrivalLabel.label.text = ride.path.endLocationName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
