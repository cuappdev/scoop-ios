//
//  PostRideLocationViewController.swift
//  Scoop
//
//  Created by Elvis Marcelo on 3/9/22.
//

import UIKit
import GooglePlaces

class PostRideLocationViewController: UIViewController {
    
    private var containerView = UIView()
    
    private let transportationPicker = UIPickerView()
    private let transportationMethodLabel = UILabel()
    private let transportationTextField = UITextField()
    
    private let arrivalTextField = UITextField()
    private let departureTextField = UITextField()
    private let locationLabel = UILabel()
    
    private let fieldSpace = 40
    private let labelSpace = 5
    private let textFieldSpace = 20
    //TODO: Placeholder until default values are clarified with Backend
    private var ride = Ride(id: 0, creator: BaseUser(id: 0, netid: "", firstName: "", lastName: "", profilePicUrl: "", grade: "", pronouns: ""), maxTravelers: 0, minTravelers: 0, departureDatetime: "", isFlexible: true, path: Path(id: 0, startLocationPlaceId: "", startLocationName: "", endLocationPlaceId: "", endLocationName: ""), type: "")
    private var methods = ["Student Driver", "Shared Taxi"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Trip Details"
        
        let nextAction = UIAction { _ in
            guard let method = self.transportationTextField.text, !method.isEmpty,
                  let departureLocation = self.departureTextField.text, !departureLocation.isEmpty,
                  let arrivalLocation = self.arrivalTextField.text, !arrivalLocation.isEmpty else {
                      self.presentErrorAlert(title: "Error", message: "Please complete all fields.")
                      return
                  }
            
            self.ride.path.startLocationName = departureLocation
            self.ride.path.endLocationName = arrivalLocation
            
            self.navigationController?.pushViewController(PostRideTripDetailsViewController(ride: self.ride), animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", image: nil, primaryAction: nextAction, menu: nil)
        
        setupContainerView()
        setupTransporationMethod()
        setupLocation()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .clear
        containerView.clipsToBounds = true
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupTransporationMethod() {
        transportationMethodLabel.text = "Method of Transportation"
        transportationMethodLabel.textColor = .black
        containerView.addSubview(transportationMethodLabel)
        
        transportationMethodLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(fieldSpace)
            make.centerX.equalToSuperview()
        }
        
        transportationPicker.delegate = self
        transportationPicker.dataSource = self
        
        transportationTextField.delegate = self
        transportationTextField.placeholder = "select"
        transportationTextField.textColor = .black
        transportationTextField.inputView = transportationPicker
        containerView.addSubview(transportationTextField)
        
        transportationTextField.snp.makeConstraints { make in
            make.leading.equalTo(transportationMethodLabel)
            make.top.equalTo(transportationMethodLabel.snp.bottom).offset(labelSpace)
            make.trailing.equalToSuperview()
        }
    }
    
    private func setupLocation() {
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
        departureTextField.addTarget(self, action: #selector(presentDepartureSearch), for: .touchDown)
        containerView.addSubview(departureTextField)
        
        departureTextField.snp.makeConstraints { make in
            make.top.equalTo(transportationImageView)
            make.leading.equalTo(transportationImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
        }
        
        arrivalTextField.placeholder = "arrival location"
        arrivalTextField.textColor = .black
        arrivalTextField.addTarget(self, action: #selector(presentArrivalSearch), for: .touchDown)
        containerView.addSubview(arrivalTextField)
        
        arrivalTextField.snp.makeConstraints { make in
            make.leading.equalTo(destinationImageView.snp.trailing).offset(10)
            make.top.equalTo(destinationImageView)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(fieldSpace)
        }
    }
    
    @objc private func presentDepartureSearch() {
        let depatureVC = DepartureSearchViewController()
        depatureVC.delegate = self
        navigationController?.pushViewController(depatureVC, animated: true)
    }

    @objc private func presentArrivalSearch() {
        let arrivalVC = ArrivalSearchViewController()
        arrivalVC.delegate = self
        navigationController?.pushViewController(arrivalVC, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension PostRideLocationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}

// MARK: - UIPickerViewDelegate
extension PostRideLocationViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == transportationPicker {
            return methods[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == transportationPicker {
            transportationTextField.text = methods[row]
        }
    }
    
}

// MARK: - UIPickerViewDataSource
extension PostRideLocationViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == transportationPicker {
            return methods.count
        }
        return 0
    }
    
}

extension PostRideLocationViewController: SearchInitialViewControllerDelegate {
    
    func didSelectLocation(viewController: UIViewController, location: GMSPlace) {
        if viewController is DepartureSearchViewController {
            departureTextField.text = location.name
        } else if viewController is ArrivalSearchViewController {
            arrivalTextField.text = location.name
        }
    }
    
}

