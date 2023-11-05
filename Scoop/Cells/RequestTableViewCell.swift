//
//  ReuqestTableViewCell.swift
//  Scoop
//
//  Created by Tiffany Pan on 3/8/23.
//

import SDWebImage
import UIKit

class RequestTableViewCell: UITableViewCell {
    
    // MARK: - Views
    
    private let profileImageView = UIImageView()
    private let requestDetailLabel = UILabel()
    private let acceptButton = UIButton()
    private let declineButton = UIButton()
    
    private var request: RideRequest?
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    // MARK: - Setup View Functions
    
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
        requestDetailLabel.lineBreakMode = .byTruncatingTail
        requestDetailLabel.numberOfLines = 2
        contentView.addSubview(requestDetailLabel)
        
        requestDetailLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-15)
            if let request = request?.approved {
                make.centerY.equalToSuperview()
            }
            make.top.equalToSuperview().offset(18)
        }
    }
    
    private func setupDeclineButton() {
        // Source: https://sarunw.com/posts/new-way-to-style-uibutton-in-ios15/
        // This button setup code with configurations can definitely be refactored in a future PR
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.bordered()
            configuration.baseForegroundColor = UIColor.scooped.primaryGrey
            configuration.baseBackgroundColor = UIColor.white
            configuration.background.strokeColor = UIColor.scooped.mutedGrey
            configuration.title = "Decline"
            configuration.titleAlignment = .center
            configuration.background.cornerRadius = 100
            declineButton.configuration = configuration
        } else {
            // Fallback on earlier versions
            declineButton.backgroundColor = UIColor.white
            declineButton.setTitle("Decline", for: .normal)
            declineButton.setTitleColor(UIColor.scooped.scoopGreen, for: .normal)
            declineButton.layer.cornerRadius = 100
            declineButton.contentHorizontalAlignment = .center
        }
        
        declineButton.addTarget(self, action: #selector(denyRequest), for: .touchUpInside)
        contentView.addSubview(declineButton)
        declineButton.snp.makeConstraints { make in
            make.leading.equalTo(requestDetailLabel.snp.leading)
            make.width.equalTo(127)
            make.height.equalTo(37)
            make.top.equalTo(requestDetailLabel.snp.bottom).offset(5)
        }
    }
    
    private func setupAcceptButton() {
        // Source: https://sarunw.com/posts/new-way-to-style-uibutton-in-ios15/
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.baseForegroundColor = UIColor.white
            configuration.baseBackgroundColor = UIColor.scooped.scoopDarkGreen
            configuration.title = "Accept"
            configuration.titleAlignment = .center
            configuration.background.cornerRadius = 100
            acceptButton.configuration = configuration
        } else {
            // Fallback on earlier versions
            acceptButton.setTitle("Accept", for: .normal)
            acceptButton.setTitleColor(.white, for: .normal)
            acceptButton.layer.cornerRadius = 10
            acceptButton.backgroundColor = UIColor.scooped.scoopDarkGreen
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
    
    // MARK: - Helper Functions
    
    private func setupViews(request: RideRequest) {
        /** Check to see if you are the approver (the one who needs to accept/deny if not yet already)
         Another users sends THIS user a request to join THIS user's ride. Give option to decline/accept i.e. this user is the APPROVER */
        print("Approver: \(request.approver.firstName)")
        print("Approvee: \(request.approvee.firstName)")
        if NetworkManager.shared.currentUser.id == request.approver.id {
            setupProfilePictureView()
            setupRequestDetailLabel()
            
            if let approved = self.request?.approved {
                // has already been approved/denied already so display its status
                let status = approved ? "approved" : "denied"
                self.requestDetailLabel.text = "You've \(status) \(request.approvee.firstName)'s request to join drive to \(request.ride.path.endLocationName)"
            } else {
                // approved is NULL - so need to accept/deny the request as the user
                self.requestDetailLabel.text = "\(request.approvee.firstName) requests to join your drive to \(request.ride.path.endLocationName)"
                setupDeclineButton()
                setupAcceptButton()
            }
            
        } else {
            /** Else, you are the approvee, so display whether or not the other party has accepted or denied your request
             THIS user has previously sent a request to another user, i.e. this user is the APPROVEE */
            setupProfilePictureView()
            setupRequestDetailLabel()
            
            if let approved = self.request?.approved {
                self.requestDetailLabel.text = approved ? "\(request.approver.firstName) accepted your request to join their drive to \(request.ride.path.endLocationName)" : "\(request.approver.firstName) denied your request to join their drive to \(request.ride.path.endLocationName)"
            } else {
                // Your request is still pending approval
                self.requestDetailLabel.text = "Your request to join \(request.approver.firstName)'s ride to \(request.ride.path.endLocationName) is still pending"
            }
        }
    }
    
    @objc func denyRequest() {
        // TODO: Networking still needs to be fixed ?!
        if let request = self.request {
            NetworkManager.shared.handleRideRequest(requestID: request.id, approved: false) { [weak self] response in
                switch response {
                case .success(let request):
                    guard let strongSelf = self else { return }
                    
                    strongSelf.requestDetailLabel.text = "You've declined \(request.approvee.firstName)'s request to join your drive to \(request.ride.path.endLocationName)"
                    strongSelf.declineButton.isHidden = true
                    strongSelf.acceptButton.isHidden = true
                    
                    strongSelf.requestDetailLabel.snp.removeConstraints()
                    strongSelf.requestDetailLabel.snp.makeConstraints { make in
                        make.leading.equalTo(strongSelf.profileImageView.snp.trailing).offset(20)
                        make.trailing.equalToSuperview().offset(-15)
                        make.top.equalTo(strongSelf.profileImageView.snp.top)
                    }
                case .failure(let error):
                    print("Unable to get all rides: \(error.localizedDescription)")
                }
            }
        }
    }

    @objc func acceptRequest() {
        if let request = self.request {
            NetworkManager.shared.handleRideRequest(requestID: request.id, approved: true) { [weak self] response in
                print("request ID: \(request.id)")
                switch response {
                case .success(let request):
                    guard let strongSelf = self else { return }
                    
                    strongSelf.requestDetailLabel.text = "You've accepted \(request.approvee.firstName)'s request to join your drive to \(request.ride.path.endLocationName)"
                    strongSelf.declineButton.isHidden = true
                    strongSelf.acceptButton.isHidden = true

                    strongSelf.requestDetailLabel.snp.removeConstraints()
                    strongSelf.requestDetailLabel.snp.makeConstraints { make in
                        make.leading.equalTo(strongSelf.profileImageView.snp.trailing).offset(20)
                        make.trailing.equalToSuperview().offset(-15)
                        make.top.equalTo(strongSelf.profileImageView.snp.top)
                    }
                case .failure(let error):
                    print("Unable to accept request: \(error.localizedDescription)")
                }
            }
        }
        
    }
    
    func configure(request: RideRequest) {
        if let url = request.approver.profilePicUrl {
            profileImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "emptyimage"))
        }
        self.request = request
        setupViews(request: request)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
