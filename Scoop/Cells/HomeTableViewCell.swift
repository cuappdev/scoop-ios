//
//  HomeTableViewCell.swift
//  Scoop
//
//  Created by Reade Plunkett on 4/21/22.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    var selectedRide: Ride?
    
    // MARK: - Views
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let depatureLabel = ImageLabelView()
    private let arrivalLabel = ImageLabelView()
    private let dateLabel = ImageLabelView()
    private let dotsImageView = UIImageView()
    
    // MARK: - Initializers
    
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
    
    // MARK: - Setup View Functions
    
    private func setupContainerView() {
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = false
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .white
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOffset = CGSize(width: 2, height: 4)
        containerView.layer.shouldRasterize = true
        containerView.layer.rasterizationScale = UIScreen.main.scale
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5)
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func setupDateLabel() {
        dateLabel.imageView.image = UIImage(named: "date")
        dateLabel.label.font = UIFont(name: "SFProDisplay-Regular", size: 16)
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
        depatureLabel.imageView.image = UIImage(named: "locationIcon")
        depatureLabel.label.font = UIFont(name: "SFProDisplay-Regular", size: 16)
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
        arrivalLabel.imageView.image = UIImage(named: "destinationIcon")
        arrivalLabel.label.font = UIFont(name: "SFProDisplay-Regular", size: 16)
        containerView.addSubview(arrivalLabel)
        
        arrivalLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(dotsImageView.snp.bottom).offset(5)
            make.bottom.equalToSuperview().inset(15)
        }
    }
    
    /// Reformats a date string to only contain the month and day , i.e. [Mar 26] from "yyyy-MM-dd'T'HH:mm:ssZ" -> "MMM dd"
    private func formatDate(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM d, h:mm a"
        
        if let date = dateFormatterGet.date(from: date) {
            return dateFormatterPrint.string(from: date)
        }
        // Return the original date string if the conversion was not successfully
        return date
    }
    
    func configure(ride: Ride) {
        selectedRide = ride
        dateLabel.label.text = formatDate(date: ride.departureDatetime)
        titleLabel.text = "\(ride.creator.firstName)'s Ride"
        depatureLabel.label.text = ride.path.startLocationName
        arrivalLabel.label.text = ride.path.endLocationName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
