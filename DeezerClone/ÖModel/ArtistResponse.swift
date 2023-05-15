//
//  ArtistsResponse.swift
//  DeezerClone
//
//  Created by Münevver Elif Ay on 13.05.2023.
//

import Foundation
// MARK: - Artist

struct ArtistResponse: Codable {
    let data: [Artist]?
}

// MARK: - GenreArtist
struct Artist: Codable {
    let id: Int?
    let picture, name: String?
    let picture_small, picture_medium, picture_big, picture_xl: String?
    let radio: Bool?
    let tracklist: String?
    let type: String?
}
