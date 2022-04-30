//
//  SearchViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/9/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let findTripsLabel = UILabel()
    private let tripInfoStackView = UIStackView()
    private let tripInfoContainerView = UIView()
    private let findTripsButton = UIButton()
    
    private let departLocationTextField = UITextField()
    private let arrivalTextField = UITextField()
    private let departureTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Find Trips"
        
        setupTripInfoView()
        setupButton()
    }
    
    func setupTripInfoView() {
        tripInfoContainerView.backgroundColor = .systemGray5
        tripInfoContainerView.layer.cornerRadius = 16
        view.addSubview(tripInfoContainerView)
        
        tripInfoContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(225)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        tripInfoStackView.axis = .vertical
        tripInfoStackView.distribution = .fill
        tripInfoStackView.spacing = 25
        tripInfoStackView.alignment = .leading
        tripInfoContainerView.addSubview(tripInfoStackView)
 
        tripInfoStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(40)
        }
        
        let departLocationView = UIView()
        let departLocationImageView = UIImageView(image: UIImage(systemName: "location", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)))
        departLocationView.tintColor = .black
        
        departLocationView.addSubview(departLocationImageView)
        
        departLocationTextField.placeholder = "departure location"
        departLocationView.addSubview(departLocationTextField)
        departLocationTextField.addTarget(self, action: #selector(presentDepartureSearch), for: UIControl.Event.touchDown)
        
        departLocationTextField.snp.makeConstraints { make in
            make.leading.equalTo(departLocationImageView.snp.trailing).offset(10)
        }
        
        tripInfoStackView.addArrangedSubview(departLocationView)
        
        departLocationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(departLocationImageView.snp.height)
        }
                
        let arrivalView = UIView()
    
        let arrivalImageView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)))
        arrivalImageView.tintColor = .black
        arrivalView.addSubview(arrivalImageView)
        
        arrivalTextField.placeholder = "arrival location"
        arrivalView.addSubview(arrivalTextField)
        arrivalTextField.addTarget(self, action: #selector(arrivalSearch), for: UIControl.Event.touchDown)
        
        arrivalTextField.snp.makeConstraints { make in
            make.leading.equalTo(arrivalImageView.snp.trailing).offset(10)
        }

        tripInfoStackView.addArrangedSubview(arrivalView)

        arrivalView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(arrivalImageView.snp.height)
        }
        
        let departureView = UIView()
        let departureImageView = UIImageView(image: UIImage(systemName: "calendar", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)))
        departureImageView.tintColor = .black
        departureView.addSubview(departureImageView)
        
        departureTextField.placeholder = "departure date"
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .clear
        /*
         This line is to get rid of the background on the UIDatePicker
         datePicker.subviews[0].subviews[0].subviews[0].alpha = 0
         */
        datePicker.setValue(UIColor.systemGray, forKey: "textColor")
        departureView.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(openDatePicker), for: .touchDown)
        departureView.addSubview(datePicker)

        datePicker.snp.makeConstraints { make in
            make.leading.equalTo(departureImageView.snp.trailing)
            make.centerY.equalTo(departureImageView.snp.centerY)
        }

        tripInfoStackView.addArrangedSubview(departureView)
        departureView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(departureImageView.snp.height)
        }
    }
    
    func setupButton() {
        findTripsButton.setTitle("Find Trips", for: .normal)
        findTripsButton.backgroundColor = .black
        findTripsButton.layer.cornerRadius = 16
        findTripsButton.addTarget(self, action: #selector(presentMatches), for: .touchDown)
        findTripsButton.backgroundColor = UIColor(red: 58/255, green: 146/255, blue: 117/255, alpha: 1)
        view.addSubview(findTripsButton)
        
        findTripsButton.snp.makeConstraints { make in
            make.top.equalTo(tripInfoContainerView.snp.bottom).offset(40)
            make.width.equalTo(tripInfoContainerView.snp.width).inset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
        }
    }
    
    @objc func presentDepartureSearch() {
        let depatureVC = DepartureSearchViewController()
        depatureVC.delegate = self
        navigationController?.pushViewController(depatureVC, animated: true)
    }

    @objc func arrivalSearch() {
        let arrivalVC = ArrivalSearchViewController()
        arrivalVC.delegate = self
        navigationController?.pushViewController(arrivalVC, animated: true)
    }
    
    @objc func presentMatches() {
        navigationController?.pushViewController(MatchesViewController(), animated: true)
    }
    
    @objc func openDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        departureTextField.inputView = datePicker
    }
}

extension SearchViewController: SearchInitialViewControllerDelegate {
    
    func didSelectLocation(viewController: UIViewController, location: String) {
        if viewController is DepartureSearchViewController {
            departLocationTextField.text = location
        } else if viewController is ArrivalSearchViewController {
            arrivalTextField.text = location
        }
    }
}