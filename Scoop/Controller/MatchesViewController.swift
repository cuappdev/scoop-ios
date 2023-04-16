//
//  MatchesViewController.swift
//  Scoop
//
//  Created by Elvis Marcelo on 4/27/22.
//

import UIKit

class MatchesViewController: UIViewController {
    
    // MARK: Views
    private let arrivalIconImageView = UIImageView(image: UIImage(named: "destinationIcon"))
    private let arrivalLocationLabel = UILabel()
    private let calendarIconImageView = UIImageView(image: UIImage(named: "calendarIcon"))
    private let departureDateLabel = UILabel()
    private let departureIconImageView = UIImageView(image: UIImage(named: "locationIcon"))
    private let departureLocationLabel = UILabel()
    private let filterView = UIView()
    private let gradientView = UIView()
    private let iconSeparatorImageView = UIImageView(image: UIImage(named: "iconSeperator"))
    private let sharedTaxiButton = UIButton()
    private let studentDriverButton = UIButton()
    private let tableView = UITableView()
    private let tripDetailsView = UIView()
    
    // MARK: Identifiers
    private let homeCellIdenitifer = "HomeCell"
    
    var arrivalName: String = "Arrival"
    var departureDate: String = "Departure"
    var departureName: String = "Date"
    var filteredRides: [Ride] = []
    var matchedRides: [Ride] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Best Matches"
        
        // MARK: Dummy Data, replace once backend fixed
//        matchedRides = [
//            Ride(id: 1, creator: BaseUser(id: 1, netid: "", firstName: "Elvis", lastName: "", phoneNumber: "", grade: "", pronouns: "", prompts: [], rides: []), maxTravelers: 1, minTravelers: 9, departureDatetime: "", isFlexible: true, path: Constants.defaultPath, type: "Student Driver"),
//            Ride(id: 1, creator: BaseUser(id: 1, netid: "", firstName: "Richie", lastName: "", phoneNumber: "", grade: "", pronouns: "", prompts: [], rides: []), maxTravelers: 1, minTravelers: 9, departureDatetime: "", isFlexible: true, path: Constants.defaultPath, type: "Student Driver"),
//            Ride(id: 1, creator: BaseUser(id: 1, netid: "", firstName: "Tiffany", lastName: "", phoneNumber: "", grade: "", pronouns: "", prompts: [], rides: []), maxTravelers: 1, minTravelers: 9, departureDatetime: "", isFlexible: true, path: Constants.defaultPath, type: "Shared Taxi"),
//            Ride(id: 1, creator: BaseUser(id: 1, netid: "", firstName: "Aarushi", lastName: "", phoneNumber: "", grade: "", pronouns: "", prompts: [], rides: []), maxTravelers: 1, minTravelers: 9, departureDatetime: "", isFlexible: true, path: Constants.defaultPath, type: "Shared Taxi"),
//            Ride(id: 1, creator: BaseUser(id: 1, netid: "", firstName: "Reade", lastName: "", phoneNumber: "", grade: "", pronouns: "", prompts: [], rides: []), maxTravelers: 1, minTravelers: 9, departureDatetime: "", isFlexible: true, path: Constants.defaultPath, type: "Student Driver"),
//            Ride(id: 1, creator: BaseUser(id: 1, netid: "", firstName: "Vin", lastName: "", phoneNumber: "", grade: "", pronouns: "", prompts: [], rides: []), maxTravelers: 1, minTravelers: 9, departureDatetime: "", isFlexible: true, path: Constants.defaultPath, type: "Shared Taxi"),
//        ]
//        filteredRides = matchedRides
        
        setupTitleLines()
        setupTripDetails()
        setupFilterButtons()
        setupTableView()
    }
    
    init(arrival: String, departure: String, date: String, rides: [Ride]) {
        super.init(nibName: nil, bundle: nil)
        self.arrivalName = arrival
        self.departureName = departure
        self.departureDate = date
        self.matchedRides = rides
        self.filteredRides = rides
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: homeCellIdenitifer)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(filterView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupTripDetails() {
        let iconTextSpacing = 10
        let iconSize = 20
        let spacing = 16
        
        tripDetailsView.backgroundColor = .white
        tripDetailsView.addDropShadow()
        tripDetailsView.layer.cornerRadius = 10
        tripDetailsView.addSubview(departureIconImageView)
        
        departureIconImageView.snp.makeConstraints { make in
            make.size.equalTo(iconSize)
            make.leading.equalToSuperview().inset(spacing)
            make.top.equalToSuperview().inset(spacing)
        }
        
        departureLocationLabel.text = departureName
        departureLocationLabel.font = .systemFont(ofSize: 16)
        tripDetailsView.addSubview(departureLocationLabel)
        
        departureLocationLabel.snp.makeConstraints { make in
            make.leading.equalTo(departureIconImageView.snp.trailing).inset(-iconTextSpacing)
            make.trailing.equalToSuperview().inset(spacing)
            make.top.equalTo(departureIconImageView)
        }
        
        tripDetailsView.addSubview(iconSeparatorImageView)
        
        iconSeparatorImageView.snp.makeConstraints { make in
            make.height.equalTo(8)
            make.width.equalTo(1.5)
            make.leading.equalTo(departureIconImageView).inset(8)
            make.top.equalTo(departureIconImageView.snp.bottom).offset(5)
        }
        
        tripDetailsView.addSubview(arrivalIconImageView)
        
        arrivalIconImageView.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.equalTo(20)
            make.leading.equalTo(departureIconImageView)
            make.top.equalTo(iconSeparatorImageView.snp.bottom).inset(-5)
        }
        
        arrivalLocationLabel.text = arrivalName
        arrivalLocationLabel.font = .systemFont(ofSize: 16)
        tripDetailsView.addSubview(arrivalLocationLabel)
        
        arrivalLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(arrivalIconImageView)
            make.trailing.equalToSuperview().inset(spacing)
            make.leading.equalTo(arrivalIconImageView.snp.trailing).inset(-iconTextSpacing)
        }
        
        tripDetailsView.addSubview(calendarIconImageView)
        
        calendarIconImageView.snp.makeConstraints { make in
            make.size.equalTo(iconSize)
            make.top.equalTo(arrivalIconImageView.snp.bottom).inset(-12)
            make.leading.equalTo(departureIconImageView)
        }
        
        departureDateLabel.text = departureDate
        departureDateLabel.font = .systemFont(ofSize: 16)
        tripDetailsView.addSubview(departureDateLabel)
        
        departureDateLabel.snp.makeConstraints { make in
            make.top.equalTo(calendarIconImageView)
            make.trailing.equalToSuperview().inset(spacing)
            make.leading.equalTo(calendarIconImageView.snp.trailing).inset(-iconTextSpacing)
        }
        
        view.addSubview(tripDetailsView)
        
        tripDetailsView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(120)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(128)
        }
    }
    
    private func setupTitleLines() {
        let dottedLineMultiplier = 0.52
        let solidLineVerticalInset = -12.75
        let solidLineMultiplier = 0.32
        let screenSize = UIScreen.main.bounds
        let dottedline = UIImageView(image: UIImage(named: "dottedline"))
        
        dottedline.contentMode = .scaleAspectFit
        view.addSubview(dottedline)
        
        dottedline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(screenSize.width*dottedLineMultiplier)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        let solidline = UIView()
        solidline.backgroundColor = .black
        view.addSubview(solidline)
        
        solidline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(screenSize.width*solidLineMultiplier)
            make.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(solidLineVerticalInset)
        }
    }
    
    private func setupFilterButtons() {
        let buttonWidth = 130
        
        [studentDriverButton, sharedTaxiButton].forEach { button in
            button.setTitleColor(.offBlack, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.offBlack.cgColor
            button.layer.cornerRadius = 16
        }
        
        studentDriverButton.setTitle("Student Driver", for: .normal)
        studentDriverButton.addTarget(self, action: #selector(studentDriverClicked), for: .touchUpInside)
        filterView.addSubview(studentDriverButton)

        studentDriverButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(buttonWidth)
        }
        
        sharedTaxiButton.setTitle("Shared Taxi", for: .normal)
        sharedTaxiButton.addTarget(self, action: #selector(sharedTaxiClicked), for: .touchUpInside)
        filterView.addSubview(sharedTaxiButton)
        
        sharedTaxiButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(studentDriverButton.snp.trailing).inset(-16)
            make.bottom.equalToSuperview()
            make.width.equalTo(buttonWidth)
        }
        
        view.addSubview(filterView)
        
        filterView.snp.makeConstraints { make in
            make.top.equalTo(tripDetailsView.snp.bottom).inset(-24)
            make.leading.trailing.equalTo(tripDetailsView)
            make.height.equalTo(32)
        }
    }
    
    private func filterRides() {
        if studentDriverButton.isSelected && sharedTaxiButton.isSelected {
            filteredRides = matchedRides
        } else if studentDriverButton.isSelected {
            filteredRides = matchedRides.filter({ ride in
                ride.type == "Student Driver"
            })
        } else if sharedTaxiButton.isSelected {
            filteredRides = matchedRides.filter({ ride in
                ride.type == "Shared Taxi"
            })
        } else {
            filteredRides = matchedRides
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func studentDriverClicked() {
        studentDriverButton.isSelected.toggle()
        studentDriverButton.setTitleColor(studentDriverButton.isSelected ? .white : .offBlack, for: .normal)
        studentDriverButton.backgroundColor = studentDriverButton.isSelected ? .scoopDarkGreen : .white
        studentDriverButton.layer.borderColor = studentDriverButton.isSelected ? UIColor.scoopDarkGreen.cgColor : UIColor.offBlack.cgColor
        filterRides()
    }
    
    @objc private func sharedTaxiClicked() {
        sharedTaxiButton.isSelected.toggle()
        sharedTaxiButton.setTitleColor(sharedTaxiButton.isSelected ? .white : .offBlack, for: .normal)
        sharedTaxiButton.backgroundColor = sharedTaxiButton.isSelected ? .scoopDarkGreen : .white
        sharedTaxiButton.layer.borderColor = sharedTaxiButton.isSelected ? UIColor.scoopDarkGreen.cgColor : UIColor.offBlack.cgColor
        filterRides()
    }

}

extension MatchesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeCellIdenitifer, for: indexPath) as! HomeTableViewCell
        cell.configure(ride: filteredRides[indexPath.row])
        return cell
    }
    
}

extension MatchesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeCellIdenitifer, for: indexPath) as! HomeTableViewCell
        let currentRide = filteredRides[indexPath.row]
        
        let tripDetailView = TripDetailsViewController(currentRide: currentRide)
        tripDetailView.hideRequestButton()
        tripDetailView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(tripDetailView, animated: true)
    }
    
}
