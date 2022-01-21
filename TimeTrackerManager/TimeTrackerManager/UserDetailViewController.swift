//
//  UserDetailViewController.swift
//  TimeTrackerManager
//
//  Created by Bocanu Mihai on 18.01.2022.
//

import UIKit

final class UserDetailViewController: UIViewController {
    let userDetail: UserCell

	private let profilePictureImageView = UIImageView()

	init(userDetail: UserCell) {
		self.userDetail = userDetail
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .systemBackground

		setupViewHierarchy()
		loadImage()
    }

    private func setupViewHierarchy() {
		profilePictureImageView.contentMode = .scaleAspectFit
		view.addSubview(profilePictureImageView)
		profilePictureImageView.translatesAutoresizingMaskIntoConstraints = false

		let horizontalSpacing: CGFloat = 24
		NSLayoutConstraint.activate([
			profilePictureImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			profilePictureImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
			profilePictureImageView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalSpacing),
			profilePictureImageView.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalSpacing),
		])
    }

	private func loadImage() {
		DispatchQueue.global().async { [self] in
			if let data = try? Data(contentsOf: userDetail.profilePictureURLOrDefault),
			   let image = UIImage(data: data) {
				DispatchQueue.main.async {
					profilePictureImageView.image = image
				}
			} else {
				profilePictureImageView.image = UIImage(systemName: "xmark.icloud")!
			}
		}
	}
}
