//
//  GenresResponse.swift
//  DeezerClone
//
//  Created by Münevver Elif Ay on 13.05.2023.
//

import Foundation
// MARK: - Genres
struct GenresResponse: Codable {
    let data: [Genre]?
}
// MARK: Genre
struct Genre: Codable {
    let id: Int?
    let picture, name: String?
    let picture_small, picture_medium, picture_big, picture_xl: String?
    let type: String?
}
