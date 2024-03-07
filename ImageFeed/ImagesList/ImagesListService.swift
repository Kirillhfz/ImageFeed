//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Kirill Kornakov on 25.02.2024.
//

import Foundation

final class ImagesListService {
    
    // MARK: - Properties
    static let shared = ImagesListService()
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private let dateFormatter = ISO8601DateFormatter()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private init(){}
    
    // MARK: - Public Methods
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard let token = oauth2TokenStorage.token else { return }
        guard let request = imageTokenRequest(token, page: String(nextPage), perPage: "10") else { return }
        let task = urlSession.objectTask(for: request){ [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    body.forEach { photoResult in
                        self.photos.append(
                            Photo(
                                id: photoResult.id,
                                size: CGSize(
                                    width: photoResult.width,
                                    height: photoResult.height
                                ),
                                createdAt: self.dateFormatter.date(from:photoResult.createdAt ?? ""),
                                welcomeDescription: photoResult.description,
                                thumbImageURL: photoResult.urls?.thumbImageURL,
                                largeImageURL: photoResult.urls?.largeImageURL,
                                isLiked: photoResult.likedByUser ?? false
                            )
                        )
                    }
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: ["Images" : self.photos])
                    self.task = nil
                case .failure:
                    assertionFailure("No images")
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(
        photoId: String,
        isLike: Bool,
        _ completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        task?.cancel()
        if task != nil { return }
        guard let token = oauth2TokenStorage.token else { return }
        let request = isLike ? deleteLikeRequest(token, photoId: photoId) : likeRequest(token, photoId: photoId)
        guard let request = request else { return }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let isLiked = body.photo?.likedByUser ?? false
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: isLiked
                        )
                        self.photos[index] = newPhoto
                    }
                    completion(.success(isLiked))
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        self.task = task
        task.resume()
    }
}

// MARK: - Extension
extension ImagesListService {
    func imageTokenRequest(_ token: String, page: String, perPage: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos?page=\(page)&&per_page=\(perPage)",
            httpMethod: "GET",
            baseURL: URL(string: "\(DefaultBaseUrl)")!)
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func likeRequest(_ token: String, photoId: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "photos/\(photoId)/like",
            httpMethod: "POST",
            baseURL: URL(string: "\(DefaultBaseUrl)")!)
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func deleteLikeRequest(_ token: String, photoId: String) -> URLRequest? {
        var request = URLRequest.makeHTTPRequest(
            path: "photos/\(photoId)/like",
            httpMethod: "DELETE",
            baseURL: URL(string: "\(DefaultBaseUrl)")!)
        request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func withReplaced(itemAt: Int, newValue: Photo) -> [Photo] {
        var item = ImagesListService.shared.photos
        item.replaceSubrange(itemAt...itemAt, with: [newValue])
        return item
    }
}
