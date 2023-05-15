//
//  TrackResponse.swift
//  DeezerClone
//
//  Created by Münevver Elif Ay on 14.05.2023.
//

import Foundation

// MARK: - TrackResponse
struct TrackResponse: Codable {
    let id: Int
//    let readable: Bool
    let title: String
//    let link, share: String
//    let duration, trackPosition, diskNumber, rank: Int
//    let releaseDate: String
//    let explicitLyrics: Bool
//    let explicitContentLyrics, explicitContentCover: Int
    let preview: String
//    let bpm, gain: Double
//    let availableCountries: [String]
//    let type: String

    enum CodingKeys: String, CodingKey {
        case id, title
//        case releaseDate = "release_date"
        case preview
    }
}
