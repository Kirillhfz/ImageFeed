//
//  UserResultModel.swift
//  ImageFeed
//
//  Created by Kirill Kornakov on 27.12.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: [String:String]
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
