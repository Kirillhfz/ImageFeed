//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Kirill Kornakov on 07.03.2024.
//

import Foundation
import WebKit
import UIKit

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func exitProfile()
    func profileServiceObserver()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        profileServiceObserver()
    }
    
    func exitProfile() {
        OAuth2TokenStorage().token = nil
        profileService.cleanCookies()
        profileService.clean()
    }
    
    func profileServiceObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            view?.loadAvatar()
        }
        view?.loadAvatar()
    }
}
