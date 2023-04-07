//
//  ReuqestTableViewCell.swift
//  Scoop
//
//  Created by Tiffany Pan on 3/8/23.
//

import UIKit
import SDWebImage

class RequestTableViewCell: UITableViewCell {
    
    // MARK: Views
    private let profileImageView = UIImageView()
    private let requestDetailLabel = UILabel()
    private let acceptButton = UIButton()
    private let declineButton = UIButton()
    
    private var request: Request?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    private func setupProfilePictureView() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.cornerRadius = 30
        profileImageView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
    
    private func setupRequestDetailLabel() {
        requestDetailLabel.font = .systemFont(ofSize: 16)
        requestDetailLabel.lineBreakMode = .byWordWrapping
        requestDetailLabel.numberOfLines = 0
        contentView.addSubview(requestDetailLabel)
        
        requestDetailLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-15)
            if let request = self.request {
                if request.approved {
                    make.top.equalTo(profileImageView.snp.top)
                } else {
                    make.top.equalToSuperview().offset(12)
                }
            }
        }
    }
    
    private func setupDeclineButton() {
        // Source: https://sarunw.com/posts/new-way-to-style-uibutton-in-ios15/
        // This button setup code with configurations can definitely be refactored in a future PR
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.bordered()
            configuration.baseForegroundColor = UIColor.primaryGrey
            configuration.baseBackgroundColor = UIColor.white
            configuration.background.strokeColor = UIColor.mutedGrey
            configuration.title = "Decline"
            configuration.titleAlignment = .center
            configuration.background.cornerRadius = 100
            declineButton.configuration = configuration
        } else {
            // Fallback on earlier versions
            declineButton.backgroundColor = UIColor.white
            declineButton.setTitle("Decline", for: .normal)
            declineButton.setTitleColor(UIColor.scoopGreen, for: .normal)
            declineButton.layer.cornerRadius = 100
            declineButton.contentHorizontalAlignment = .center
        }
        
        declineButton.addTarget(self, action: #selector(denyRequest), for: .touchUpInside)
        contentView.addSubview(declineButton)
        declineButton.snp.makeConstraints { make in
            make.leading.equalTo(requestDetailLabel.snp.leading)
            make.width.equalTo(127)
            make.height.equalTo(37)
            make.top.equalTo(requestDetailLabel.snp.bottom).offset(10)
        }
    }
    
    private func setupAcceptButton() {
        // Source: https://sarunw.com/posts/new-way-to-style-uibutton-in-ios15/
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.baseForegroundColor = UIColor.white
            configuration.baseBackgroundColor = UIColor.scoopDarkGreen
            configuration.title = "Accept"
            configuration.titleAlignment = .center
            configuration.background.cornerRadius = 100
            acceptButton.configuration = configuration
        } else {
            // Fallback on earlier versions
            acceptButton.setTitle("Accept", for: .normal)
            acceptButton.setTitleColor(.white, for: .normal)
            acceptButton.layer.cornerRadius = 10
            acceptButton.backgroundColor = UIColor.scoopDarkGreen
        }
        
        acceptButton.addTarget(self, action: #selector(acceptRequest), for: .touchUpInside)
        contentView.addSubview(acceptButton)
        
        acceptButton.snp.makeConstraints { make in
            make.top.equalTo(declineButton.snp.top)
            make.leading.equalTo(declineButton.snp.trailing).offset(15)
            make.width.equalTo(127)
            make.height.equalTo(37)
        }
    }
    
    private func setUpViews() {
        if let request = self.request {
            if request.approved {
                // Display only the profile picture + request info.
                setupProfilePictureView()
                setupRequestDetailLabel()
            } else {
                // Give the user the option to either accept/deny the pending request.
                setupProfilePictureView()
                setupRequestDetailLabel()
                setupDeclineButton()
                setupAcceptButton()
            }
        }
    }
    
    @objc func denyRequest() {
        // TODO: Networking still needs to be fixed ?!
        if let request = self.request {
            NetworkManager.shared.handleRideRequest(requestID: request.id, approved: false) { response in
                switch response {
                case .success(let request):
                    // call should happen in here technically
                    self.requestDetailLabel.text = "You've declined \(request.approvee.firstName)'s to join your drive to \(request.ride.path.endLocationName)"
                    declineButton.isHidden = true
                    acceptButton.isHidden = true
                    
                    requestDetailLabel.snp.removeConstraints()
                    requestDetailLabel.snp.makeConstraints { make in
                        make.leading.equalTo(profileImageView.snp.trailing).offset(20)
                        make.trailing.equalToSuperview().offset(-15)
                        make.top.equalTo(profileImageView.snp.top)
                    }
                case .failure(let error):
                    print("Unable to get all rides: \(error.localizedDescription)")
                }
            }
        }
    }

    @objc func acceptRequest() {
        // TODO: Networking - pass in the correct request ID depending on the cell
        
        if let request = self.request {
            NetworkManager.shared.handleRideRequest(requestID: request.id, approved: true) { response in
                switch response {
                case .success(let request):
                    self.requestDetailLabel.text = "You've accepted \(request.approvee.firstName)'s to join your drive to \(request.ride.path.endLocationName)"
                    declineButton.isHidden = true
                    acceptButton.isHidden = true
                    
                    requestDetailLabel.snp.removeConstraints()
                    requestDetailLabel.snp.makeConstraints { make in
                        make.leading.equalTo(profileImageView.snp.trailing).offset(20)
                        make.trailing.equalToSuperview().offset(-15)
                        make.top.equalTo(profileImageView.snp.top)
                    }
                case .failure(let error):
                    print("Unable to get all rides: \(error.localizedDescription)")
                }
            }
        }
        
    }
    
    func configure(request: Request) {
        if let url = request.approvee.profilePicUrl {
            profileImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "emptyimage"))
        }
        if request.approved {
            self.requestDetailLabel.text = "\(request.approver.firstName) accepted your request to join their drive to \(request.ride.path.endLocationName)"
        } else {
            self.requestDetailLabel.text = "\(request.approvee.firstName) requests to join drive to \(request.ride.path.endLocationName)"
        }
        self.request = request
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
