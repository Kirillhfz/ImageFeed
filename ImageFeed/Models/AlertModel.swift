//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Kirill Kornakov on 26.12.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
