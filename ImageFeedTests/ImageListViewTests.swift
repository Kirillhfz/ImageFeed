//
//  ImageListTests.swift
//  ImageFeedTests
//
//  Created by Kirill Kornakov on 07.03.2024.
//

@testable import ImageFeed
import Foundation
import XCTest
import UIKit

final class ImagesListTests: XCTestCase {
        //given
    func testViewControllerCallsViewDidLoad(){
        
        let imageListService = ImagesListService.shared
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy(imagesListService: imageListService)
        viewController.presenter = presenter
        presenter.view = viewController
        //when
        _ = viewController.view
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testLike() {
        //given
        let photos: [Photo] = []
        let imagesListService = ImagesListService.shared
        let view = ImageListViewControllerSpy(photos: photos)
        let presenter = ImagesListPresenterSpy(imagesListService: imagesListService)
        view.presenter = presenter
        presenter.view = view
        //when
        view.addPhotoLike()
        //then
        XCTAssertTrue(presenter.didSetLikeCall)
    }
    
}

final class ImagesListPresenterSpy: ImagesListViewPresenterProtocol {
    func fetchPhotosNextPage() {
    }
    
    var view: ImageFeed.ImagesListViewControllerProtocol?
    
    var imagesListService: ImageFeed.ImagesListService
    
    init(imagesListService: ImagesListService){
        self.imagesListService = imagesListService
    }
    
    var didSetLikeCall: Bool = false
    
    var viewDidLoadCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func addPhotoLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        didSetLikeCall = true
    }
    
}
    

final class ImageListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListViewPresenterProtocol?
    
    func updateTableViewAnimated() {
    }
    
    var photos: [ImageFeed.Photo]
    
    init(photos: [Photo]) {
        self.photos = photos
    }
    
    func addPhotoLike() {
        presenter?.addPhotoLike(photoId: "photo", isLike: true) { [weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                break
            case .failure(_):
                print("Invalid Configuration")
            }
        }
    }
}

