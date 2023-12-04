//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Kirill Kornakov on 02.12.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var avatarImageView: UIImageView = {
        let viewImageAvatar = UIImageView()
        viewImageAvatar.image = UIImage(named: "avatar")
        viewImageAvatar.tintColor = .gray
        viewImageAvatar.contentMode = .scaleAspectFit
        viewImageAvatar.translatesAutoresizingMaskIntoConstraints = false
        return viewImageAvatar

    }()
    
    private var nameLabel: UILabel = {
        let labelName = UILabel()
        labelName.text = "Екатерина Новикова"
        labelName.textColor = .white
        labelName.font = .systemFont(ofSize: 23, weight: UIFont.Weight.bold)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        return labelName
    }()
    
    private var loginNameLabel: UILabel = {
        let labelNameLogin = UILabel()
        labelNameLogin.text = "@ekaterina_nov"
        labelNameLogin.textColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        labelNameLogin.font = .systemFont(ofSize: 13)
        labelNameLogin.translatesAutoresizingMaskIntoConstraints = false
        return labelNameLogin
    }()
    
    private var descriptionLabel: UILabel = {
       let labelDescription = UILabel ()
        labelDescription.text = "Hello, World!"
        labelDescription.textColor = .white
        labelDescription.font = .systemFont(ofSize: 13)
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        return labelDescription
    }()
    
    var  logoutButton: UIButton = {
        let buttonLogout = UIButton.systemButton(
            with: UIImage(named: "logout_button") ?? UIImage(),
            target: ProfileViewController.self,
            action: #selector(Self.didTapLogoutButton)
        )
        buttonLogout.tintColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1)
        buttonLogout.translatesAutoresizingMaskIntoConstraints = false
        return buttonLogout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @objc
    private func didTapLogoutButton() {}
}
