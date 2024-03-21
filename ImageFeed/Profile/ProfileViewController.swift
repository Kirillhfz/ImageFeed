//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Kirill Kornakov on 02.12.2023.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol { get set }
    var nameLabel: UILabel { get set }
    var loginNameLabel: UILabel { get set }
    var descriptionLabel: UILabel { get set }
    func loadAvatar()
    func showAlertExit()
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    // MARK: - Private Properties
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    
    var presenter: ProfileViewPresenterProtocol = {
        return ProfileViewPresenter()
    }()
    
    var avatarImageView: UIImageView = {
        let viewImageAvatar = UIImageView()
        viewImageAvatar.image = UIImage(named: "avatar")
        viewImageAvatar.tintColor = .gray
        viewImageAvatar.contentMode = .scaleAspectFit
        viewImageAvatar.translatesAutoresizingMaskIntoConstraints = false
        return viewImageAvatar

    }()
    
    var nameLabel: UILabel = {
        let labelName = UILabel()
        labelName.text = "Екатерина Новикова"
        labelName.textColor = .white
        labelName.font = .systemFont(ofSize: 23, weight: UIFont.Weight.bold)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        return labelName
    }()
    
    var loginNameLabel: UILabel = {
        let labelNameLogin = UILabel()
        labelNameLogin.text = "@ekaterina_nov"
        labelNameLogin.textColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        labelNameLogin.font = .systemFont(ofSize: 13)
        labelNameLogin.translatesAutoresizingMaskIntoConstraints = false
        return labelNameLogin
    }()
    
    var descriptionLabel: UILabel = {
       let labelDescription = UILabel ()
        labelDescription.text = "Hello, World!"
        labelDescription.textColor = .white
        labelDescription.font = .systemFont(ofSize: 13)
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        return labelDescription
    }()
    
    lazy var logoutButton: UIButton = {
        let buttonLogout = UIButton.systemButton(
            with: UIImage(named: "logout_button") ?? UIImage(),
            target: self,
            action: #selector(Self.didTapLogoutButton)
        )
        buttonLogout.tintColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1)
        buttonLogout.translatesAutoresizingMaskIntoConstraints = false
        return buttonLogout
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(delegate: self)
        
        view.backgroundColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        
        view.addSubview(avatarImageView)
        avatarImageViewSetup()
        
        view.addSubview(nameLabel)
        nameLabelSetup()
        
        view.addSubview(loginNameLabel)
        loginNameLabelSetup()
        
        view.addSubview(descriptionLabel)
        descriptionLabelSetup()
        
        view.addSubview(logoutButton)
        logoutButtonSetup()
        
        presenter.view = self
        presenter.viewDidLoad()
        
        updateProfileDetails(profile: profileService.profile)
    }
    
    // MARK: - Public Methods
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { return }
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    func avatarImageViewSetup() {
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
    }
    
    func nameLabelSetup() {
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    func loginNameLabelSetup() {
        loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    func descriptionLabelSetup() {
        descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    func logoutButtonSetup() {
        logoutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    // MARK: - Private Methods
    @objc
    private func didTapLogoutButton() {
        showAlertExit()
    }
}

// MARK: - Private Extension
extension ProfileViewController {
    func loadAvatar() {
        guard
            let avatarURL = profileImageService.avatarUrl,
            let profleURL = URL(string: avatarURL) else { return }
        
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: profleURL,
            placeholder: UIImage(named: "tab_profile_active"),
            options: [.processor(processor)]
        )
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 34
    }
    
    func exitProfile() {
        OAuth2TokenStorage().token = nil
        WebViewController.clean()
        profileService.clean()
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
    }
    
    func showAlertExit() {
        DispatchQueue.main.async {
            let alert = AlertModel(
                title: "Пока, пока!",
                message: "Уверены, что хотите выйти?",
                buttonText: "Да",
                completion: { [weak self] in
                    guard let self = self else { return }
                    self.exitProfile()
                },
                nextButtonText: "Нет",
                nextCompletion: { [weak self] in
                    guard let self = self else { return }
                    self.dismiss(animated: true)
                })
            
            self.alertPresenter?.showError(for: alert)
        }
    }
}
