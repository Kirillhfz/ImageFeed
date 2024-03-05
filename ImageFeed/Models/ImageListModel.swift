//
//  ImageListModel.swift
//  ImageFeed
//
//  Created by Kirill Kornakov on 24.02.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String?
    let isLiked: Bool
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let updatedAt: String?
    let width: CGFloat
    let height: CGFloat
    let likes: Int
    let likedByUser: Bool?
    let description: String?
    let urls: UrlsResult?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width = "width"
        case height = "height"
        case likes = "likes"
        case likedByUser = "liked_by_user"
        case description = "description"
        case urls = "urls"
    }
}

struct UrlsResult: Decodable {
    let thumbImageURL: String?
    let largeImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case thumbImageURL = "thumb"
        case largeImageURL = "full"
    }
}

struct LikeResult: Decodable {
    let photo: PhotoResult?
}
