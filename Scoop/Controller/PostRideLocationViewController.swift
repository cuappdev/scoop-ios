//
//  PostRideLocationViewController.swift
//  Scoop
//
//  Created by Elvis Marcelo on 3/9/22.
//

import UIKit

class PostRideLocationViewController: UIViewController {
    
    private var containerView = UIView()
    
    private let transportationMethodLabel = UILabel()
    private let transportationTextField = UITextField()
    
    private let arrivalTextField = UITextField()
    private let departureTextField = UITextField()
    private let locationLabel = UILabel()

    private let fieldSpace = 40
    private let labelSpace = 5
    private let textFieldSpace = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Trip Details"
        view.backgroundColor = .white
        
        setupContainerView()
        setupTransporationMethod()
        setupLocation()
    }
    
    func setupContainerView() {
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setupTransporationMethod() {
        transportationMethodLabel.text = "Method of Transportation"
        transportationMethodLabel.textColor = .black
        containerView.addSubview(transportationMethodLabel)
        
        transportationMethodLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(fieldSpace)
            make.centerX.equalToSuperview()
        }
        
        transportationTextField.placeholder = "select"
        transportationTextField.textColor = .black
        containerView.addSubview(transportationTextField)
        
        transportationTextField.snp.makeConstraints { make in
            make.leading.equalTo(transportationMethodLabel)
            make.top.equalTo(transportationMethodLabel.snp.bottom).offset(labelSpace)
            make.trailing.equalToSuperview()
        }
    }
        
    func setupLocation() {
        locationLabel.text = "Locations"
        locationLabel.textColor = .black
        containerView.addSubview(locationLabel)
        
        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(transportationTextField)
            make.top.equalTo(transportationTextField.snp.bottom).offset(fieldSpace)
            make.trailing.equalToSuperview()
        }
        
        let transportationImageView = UIImageView(image: UIImage(systemName: "location"))
        transportationImageView.tintColor = .black
        containerView.addSubview(transportationImageView)
        
        transportationImageView.snp.makeConstraints { make in
            make.width.equalTo(transportationImageView.snp.height)
            make.leading.equalTo(locationLabel)
            make.top.equalTo(locationLabel.snp.bottom).offset(labelSpace)
        }
        
        let destinationImageView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        destinationImageView.tintColor = .black
        containerView.addSubview(destinationImageView)
        
        destinationImageView.snp.makeConstraints { make in
            make.leading.equalTo(transportationImageView)
            make.size.equalTo(20)
            make.top.equalTo(transportationImageView.snp.bottom).offset(textFieldSpace)
            make.width.equalTo(destinationImageView.snp.height)
        }
        
        departureTextField.placeholder = "departure location"
        departureTextField.textColor = .black
        containerView.addSubview(departureTextField)
        
        departureTextField.snp.makeConstraints { make in
            make.top.equalTo(transportationImageView)
            make.leading.equalTo(transportationImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
        }
        
        arrivalTextField.placeholder = "arrival location"
        arrivalTextField.textColor = .black
        containerView.addSubview(arrivalTextField)

        arrivalTextField.snp.makeConstraints { make in
            make.leading.equalTo(destinationImageView.snp.trailing).offset(10)
            make.top.equalTo(destinationImageView)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(fieldSpace)
        }
    }
}
