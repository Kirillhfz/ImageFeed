//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Kirill Kornakov on 26.12.2023.
//

import Foundation
import WebKit

final class ProfileService {
    
    //MARK: - Private Properties
    static let shared = ProfileService()
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private(set) var profile: Profile?
    private init() {}
    
    // MARK: - Public Methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if profile != nil { return }
        task?.cancel()
        let request = profileRequest(token: token)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let profile = Profile(callData: body)
                    self.profile = profile
                    completion(.success(profile))
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        self.task = task
        task.resume()
    }
    
    func clean() {
            profile = nil
        }
}

// MARK: - Extension
extension ProfileService {
    func profileRequest(token: String) -> URLRequest {
        guard let url = URL(
            string: "\(DefaultBaseUrl)"
            + "/me")
        else {
            fatalError("Failed to create URL")
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func cleanCookies() {
       HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
       WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
           records.forEach { record in
               WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
           }
       }
   }
}
