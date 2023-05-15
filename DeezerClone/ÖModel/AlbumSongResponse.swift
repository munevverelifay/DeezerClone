//
//  AlbumDetail.swift
//  DeezerClone
//
//  Created by Münevver Elif Ay on 13.05.2023.
//

import Foundation

//struct AlbumSongDetail: Codable {
//    let data: [AlbumSongDetails]?
//    let total: Int?
//}
//
//struct AlbumSongDetails: Codable {
//    let id: Int?
//    let readable: Bool?
//    let title, title_short, title_version, isrc: String?
//    let link: String?
//    let duration: Int?
//    let track_position, disk_number: Int?
//    let rank: Int?
//    let explicit_lyrics: Bool?
//    let explicit_content_lyrics, explicit_content_cover: Int?
//    let preview: String?
//    let md5_image: String?
//    let artist: AlbumTrackArtist?
//    let type: String?
//}
//
//struct AlbumTrackArtist: Codable {
//    let id: Int?
//    let name: String?
//    let tracklist: String?
//    let type: String?
//}


// MARK: - AlbumTrack
struct AlbumSongResponse: Codable {
    let data: [AlbumSongDetails]
    let total: Int
}

// MARK: - Datum
struct AlbumSongDetails: Codable {
    let id: Int
    let readable: Bool
    let title, titleShort, titleVersion, isrc: String
    let link: String
    let duration, trackPosition, diskNumber, rank: Int
    let explicitLyrics: Bool
    let explicitContentLyrics, explicitContentCover: Int
    let preview: String
    let md5Image: String
    let artist: Artist
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id, readable, title
        case titleShort = "title_short"
        case titleVersion = "title_version"
        case isrc, link, duration
        case trackPosition = "track_position"
        case diskNumber = "disk_number"
        case rank
        case explicitLyrics = "explicit_lyrics"
        case explicitContentLyrics = "explicit_content_lyrics"
        case explicitContentCover = "explicit_content_cover"
        case preview
        case md5Image = "md5_image"
        case artist, type
    }
}
