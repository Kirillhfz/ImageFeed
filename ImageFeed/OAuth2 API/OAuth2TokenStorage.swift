//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Kirill Kornakov on 12.12.2023.
//

import Foundation

final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case token
    }
    
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            userDefaults.string(forKey: Keys.token.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
