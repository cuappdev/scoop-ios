//
//  BlockedUsersViewController.swift
//  Scoop
//
//  Created by Caitlyn Jin on 11/12/23.
//

import UIKit

class BlockedUsersViewController: UIViewController {

    // MARK: - Views

    private let emptyStateView = EmptyStateView()
    private let tableView = UITableView()

    // MARK: - User Data

    private var user: BaseUser?
    private var blockedUsers: [BaseUser] = BaseUser.blockedUsersDummyData

    // MARK: - Initializers

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        // TODO: Uncomment after networking calls are implemented
//        fetchBlockedUsers()

        setupHeader()
        blockedUsers.isEmpty ? setupEmptyStateView() : setupTableView()
    }

    // MARK: - Setup View Functions

    private func setupHeader() {
        let dottedLineMultiplier = 0.52
        let solidLineVerticalInset = -12.75
        let solidLineMultiplier = 0.32
        let screenSize = UIScreen.main.bounds
        let dottedline = UIImageView(image: UIImage.scooped.dottedLine)
        let solidline = UIView()

        dottedline.contentMode = .scaleAspectFit
        view.addSubview(dottedline)

        dottedline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(screenSize.width * dottedLineMultiplier)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }

        solidline.backgroundColor = UIColor.black
        view.addSubview(solidline)

        solidline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(screenSize.width * solidLineMultiplier)
            make.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(solidLineVerticalInset)
        }

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Blocked users"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.scooped.flowHeader]
    }

    private func setupEmptyStateView() {
        emptyStateView.setup(
            image: UIImage(),
            title: "",
            subtitle: "No blocked users"
        )
        view.addSubview(emptyStateView)

        emptyStateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupTableView() {
        tableView.register(BlockedUserTableViewCell.self, forCellReuseIdentifier: BlockedUserTableViewCell.reuse)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.leading.trailing.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().inset(50)
        }
    }

    // MARK: - Networking

    private func fetchBlockedUsers() {
        NetworkManager.shared.getBlockedUsers { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let users):
                blockedUsers = users
                tableView.reloadData()
            case .failure(let error):
                print("Error in BlockedUsersViewController: \(error.localizedDescription)")
            }
        }
    }

    private func blockUser() {
        // TODO: Network call to block user
    }

    private func unblockUser() {
        // TODO: Network call to unblock user
    }

}

extension BlockedUsersViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

}

extension BlockedUsersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockedUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BlockedUserTableViewCell.reuse, for: indexPath) as? BlockedUserTableViewCell else { return UITableViewCell() }
        let user = blockedUsers[indexPath.row]
        cell.configure(user: user, delegate: self)
        return cell
    }

}

protocol BlockedUsersDelegate: AnyObject {
    func updateBlockedUsers(user: BaseUser, isBlocked: Bool)
    func presentPopUp(popUpVC: PopUpViewController)
}

extension BlockedUsersViewController: BlockedUsersDelegate {

    func updateBlockedUsers(user: BaseUser, isBlocked: Bool) {
        if isBlocked {
            blockUser()
            // TODO: Temporary while networking call is unimplemented
            BaseUser.blockedUsersDummyData.append(user)
        } else {
            unblockUser()
            // TODO: Temporary while networking call is unimplemented
            BaseUser.blockedUsersDummyData.removeAll { $0.id == user.id }
        }
    }

    func presentPopUp(popUpVC: PopUpViewController) {
        present(popUpVC, animated: true)
    }

}
