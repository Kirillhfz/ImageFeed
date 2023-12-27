//
//  Constants.swift
//  ImageFeed
//
//  Created by Kirill Kornakov on 05.12.2023.
//

import Foundation

struct KeyAndUrl {
    static let accessKey = "RSJwpfTbOlLBsB5_ViRSVhwoNmNjQ7VwRUJMagVUu9Y"
    static let secretKey = "2KUUl0YJl84zdS6Z7-STwusqhH0s6vY69CYf3xHRYk0"
    static let redirectUrl = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseUrl = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeUrlString = "https://unsplash.com/oauth/authorize"
    static let defaultBaseApiUrl = URL(string: "https://api.unsplash.com/")!
}
