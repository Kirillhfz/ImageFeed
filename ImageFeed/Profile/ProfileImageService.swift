//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Kirill Kornakov on 26.12.2023.
//

import Foundation

final class ProfileImageService {
    
    //MARK: - Private Properties
    static let shared = ProfileImageService()
    private (set) var avatarUrl: String?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private init() {}
    
    // MARK: - Public Methods
    func fetchProfileImageURL(
        username: String,
        _ completion: @escaping (Result<String, Error>) -> Void
    ){
        assert(Thread.isMainThread)
        if avatarUrl != nil { return }
        task?.cancel()
        guard let token = oauth2TokenStorage.token else { return }
        let request = profileImageRequest(token: token, username: username)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let avatarUrl = ProfileImage(callData: body)
                self.avatarUrl = avatarUrl.smallImage["large"]
                completion(.success(self.avatarUrl ?? ""))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": self.avatarUrl as Any])
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

// MARK: - Public Methods
private extension ProfileImageService {
    private func profileImageRequest(token: String, username: String) -> URLRequest {
        guard let url = URL(
            string: "\(KeyAndUrl.defaultBaseApiUrl)" + "/users/" + username)
        else {
            fatalError("Failed to create URL")
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
