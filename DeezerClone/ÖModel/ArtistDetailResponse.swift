//
//  ArtistDetailResponse.swift
//  DeezerClone
//
//  Created by Münevver Elif Ay on 13.05.2023.
//

import Foundation

struct ArtistDetailResponse: Codable {
    let data: [ArtistDetail]?
}
struct ArtistDetail: Codable {
    let id: Int?
    let link, name, share, picture: String?
    let picture_small, picture_medium, picture_big, picture_xl: String?
    let nb_album, nb_fan: Int?
    let radio: Bool?
    let tracklist: String?
    let type: String?
}
