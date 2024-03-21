//
//  Constants.swift
//  ImageFeed
//
//  Created by Kirill Kornakov on 05.12.2023.
//

import Foundation

let AccessKey = "RSJwpfTbOlLBsB5_ViRSVhwoNmNjQ7VwRUJMagVUu9Y"
let SecretKey = "2KUUl0YJl84zdS6Z7-STwusqhH0s6vY69CYf3xHRYk0"
let RedirectUrl = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let DefaultBaseUrl = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeUrlString = "https://unsplash.com/oauth/authorize"
let DefaultBaseApiUrl = URL(string: "https://api.unsplash.com/")!

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectUrl,
                                 accessScope: AccessScope,
                                 authURLString: UnsplashAuthorizeUrlString,
                                 defaultBaseURL: DefaultBaseUrl)
    }
}
