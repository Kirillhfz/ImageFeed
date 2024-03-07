//
//  ImageListViewPresenter.swift
//  ImageFeed
//
//  Created by Kirill Kornakov on 07.03.2024.
//

import Foundation
import UIKit

protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? {get set}
    var imagesListService: ImagesListService {get}
    func viewDidLoad()
    func addPhotoLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
    func fetchPhotosNextPage()
}

final class ImageListViewPresenter: ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    let imagesListService = ImagesListService.shared
    
    func viewDidLoad() {
        configureNotificationObserver()
    }
    
    func addPhotoLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
            imagesListService.changeLike(photoId: photoId,
                                         isLike: isLike,
                                         { [weak self] result in
                guard let self = self else { return }
                switch result{
                case .success(_):
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                    print("Ошибка, возникшая при изменении типа: \(error)")
                }
            })
        }
    func configureNotificationObserver() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                view?.updateTableViewAnimated()
            }
        imagesListService.fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage(){
        imagesListService.fetchPhotosNextPage()
    }
    
}
