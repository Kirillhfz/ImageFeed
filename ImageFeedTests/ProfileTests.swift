//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Kirill Kornakov on 07.03.2024.
//

@testable import ImageFeed
import Foundation
import XCTest
import UIKit

final class ProfileTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let profileService = ProfileService.shared
        let presenter = ProfileViewPresenterSpy(profileService: profileService)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerCallsCleanCookies() {
        //given
        
        let profileService = ProfileService.shared
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfileViewPresenterSpy(profileService: profileService)
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        
        //when
        _ = profileViewController.view
        profilePresenter.exitProfile()
        
        //then
        XCTAssertTrue(profilePresenter.viewDidClearDetailsAccount)
    }
    
    
    func testPresenterCallsUpdateProfile() {
        let profileService = ProfileService.shared
        //given
        let presenter = ProfileViewPresenterSpy(profileService: profileService)
        let profileViewController = ProfileViewControllerSpy(presenter: presenter)
        let profilePresenter = ProfileViewPresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        
        let test = "test"
        let userName = "kirillhfz"
        let nameLabel = "Kirill Kornakov"
        let firstName = "Kirill"
        let lastName = "Kornakov"
        let loginNameLabel = "@kirillhfz"
        let profile = Profile(callData: ProfileResult(userName: userName,
                                                      firstName: firstName,
                                                      lastName: lastName,
                                                      bio: test))
        
        //when
        profileViewController.updateProfileDetails(profile: profile)
        
        //then
        XCTAssertTrue(profileViewController.viewDidUpdateProfileDetails)
        XCTAssertEqual(profileViewController.nameLabel.text, nameLabel)
        XCTAssertEqual(profileViewController.loginNameLabel.text, loginNameLabel)
        XCTAssertEqual(profileViewController.descriptionLabel.text, test)
    }
    
    func testExitProfile() {
        //given
        
        let profileService = ProfileService.shared
        let presenter = ProfileViewPresenterSpy(profileService: profileService)
        let view = ProfileViewControllerSpy(presenter: presenter)
        view.presenter = presenter
        presenter.view = view
        
        //when
        view.showAlertExit()
        
        //then
        XCTAssertTrue(presenter.didLogoutCalled)
    }
}

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var observer: Bool = false
    var viewDidClearDetailsAccount: Bool = false
    var didLogoutCalled: Bool = false
    var profileService: ImageFeed.ProfileService
    
    init(profileService: ProfileService){
        self.profileService = profileService
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func exitProfile() {
        viewDidClearDetailsAccount = true
        didLogoutCalled = true
    }
    
    func profileServiceObserver() {
        observer = true
    }
    
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfileViewPresenterProtocol
    
    init(presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
    }
    
    func showAlertExit() {
        presenter.exitProfile()
    }
    
    func loadAvatar() {
        updateAvatar = true
    }
    
    var nameLabel = UILabel()
    var loginNameLabel = UILabel()
    var descriptionLabel = UILabel()
    var updateAvatar: Bool = false
    var viewDidUpdateProfileDetails: Bool = false
    
    func updateProfileDetails(profile: ImageFeed.Profile?) {
        viewDidUpdateProfileDetails = true
        guard let profile = profile else { return }
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
}
