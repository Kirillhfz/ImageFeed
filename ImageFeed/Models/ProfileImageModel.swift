//
//  ProfileImageModel.swift
//  ImageFeed
//
//  Created by Kirill Kornakov on 26.12.2023.
//

import Foundation

struct ProfileImage: Codable {
    let smallImage: [String:String]
    
    init(callData: UserResult) {
        self.smallImage = callData.profileImage
    }
}
