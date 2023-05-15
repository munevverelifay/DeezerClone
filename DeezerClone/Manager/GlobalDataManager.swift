//
//  GlobalDataManager.swift
//  DeezerClone
//
//  Created by Münevver Elif Ay on 13.05.2023.
//

import Foundation
class GlobalDataManager {
    static let sharedGlobalManager = GlobalDataManager() //singletone
    var artistResults: [Artist]? = []
    var albumResults: [AlbumDetail]? = []
    var songResults: [AlbumSongDetails]? = []
    var trackResults: [TrackResponse]? = []

    
    var genreId: [Int]? = []
    var artistId: Int? 
    var albumId: Int?
    var likeSongId:[Int]? = []
    var trackId: [Int]? = []
    
    
    var favoriteSongId: [Int]? = []
    
    var artistAlbumImage: String?

    var checkPreview: Bool = false
    
    var artistSelectedIndexPath: IndexPath? = IndexPath(item: 0, section: 0)
    var albumSelectedIndexPath: IndexPath? = IndexPath(item: 0, section: 0)
    var songSelectedIndexPath: IndexPath? = IndexPath(item: 0, section: 0)

}

