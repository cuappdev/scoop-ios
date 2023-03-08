//
//  SearchViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/9/22.
//

import UIKit
import GooglePlaces

class SearchViewController: UIViewController {
    
    // MARK: Views
    private let arrivalTextField = UITextField()
    private let departLocationTextField = UITextField()
    private let departureTextField = UITextField()
    private let findTripsButton = UIButton()
    private let findTripsLabel = UILabel()
    private let tripInfoStackView = UIStackView()
    private let tripInfoContainerView = UIView()
    private let datePicker = UIDatePicker()
    
    // MARK: Data
    private var tripDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Find Trips"
        /// Default date if user does not change, set to today's date
        tripDate = formatDate(dateToConvert: Date())
        
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
            make.trailing.equalToSuperview().inset(20)
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
        departLocationTextField.addTarget(self, action: #selector(presentDepartureSearch), for: .touchDown)
        
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
        arrivalTextField.addTarget(self, action: #selector(arrivalSearch), for: .touchDown)
        
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
        
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .clear
        departureView.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(onDateValueChanged), for: .valueChanged)

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

    @objc private func presentMatches() {
        if let startLocation = departLocationTextField.text, let endLocation = arrivalTextField.text {
            NetworkManager.shared.searchLocation(depatureDate: tripDate, startLocation: startLocation, endLocation: endLocation)
            { response in
                switch response {
                case .success(let response):
                    self.navigationController?.pushViewController(MatchesViewController(rides: response.rides), animated: true)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    /** Change the value of tripDate every time the user taps on a different  day of the calendar. */
    @objc private func onDateValueChanged() {
        tripDate = formatDate(dateToConvert: datePicker.date)
    }
    
    /** Converts a Date object into String format, where this one is specifically in the YYYY-MM-dd format. */
    private func formatDate(dateToConvert: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: dateToConvert)
    }
    
}

// MARK: - SearchInitialViewControllerDelegate
extension SearchViewController: SearchInitialViewControllerDelegate {

    func didSelectLocation(viewController: UIViewController, location: GMSPlace) {
        if viewController is DepartureSearchViewController {
            departLocationTextField.text = location.name
        } else if viewController is ArrivalSearchViewController {
            arrivalTextField.text = location.name
        }
    }

}
