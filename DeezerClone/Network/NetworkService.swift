//
//  NetworkService.swift
//  DeezerClone
//
//  Created by Münevver Elif Ay on 13.05.2023.
//

import Foundation
import Alamofire

private let baseURL = "https://api.deezer.com"
class NetworkService {
    static let sharedNetwork = NetworkService()
    
    func getGenres(completion: @escaping (Result<GenresResponse, AFError>) -> Void) {
        let NetworkURL = "\(baseURL)/genre"
        AF.request(NetworkURL, method: .get).responseDecodable(of: GenresResponse.self) {
            response in completion(response.result)
        }
    }
    
    func getArtists(genre_id: Int ,completion: @escaping (Result<ArtistResponse, AFError>) -> Void) {
        let NetworkURL = "\(baseURL)/genre/\(genre_id)/artists"
        AF.request(NetworkURL, method: .get).responseDecodable(of: ArtistResponse.self) {
            response in completion(response.result)
        }
    }
    
    func getArtistDetail(artist_id: Int, completion: @escaping (Result<ArtistDetailResponse, AFError>) -> Void) {
        let NetworkURL = "\(baseURL)/artist/\(artist_id)"
        AF.request(NetworkURL, method: .get).responseDecodable(of: ArtistDetailResponse.self) {
            response in completion(response.result)
        }
    }
    
    func getArtistAlbum(artist_id: Int, completion: @escaping (Result<ArtistAlbumsResponse, AFError>) -> Void) {

        let NetworkURL = "\(baseURL)/artist/\(artist_id)/albums"
        AF.request(NetworkURL, method: .get).responseDecodable(of: ArtistAlbumsResponse.self) {
            response in completion(response.result)
        }
    }
    
    func getAlbum(album_id: Int, completion: @escaping (Result<AlbumSongResponse, AFError>) -> Void) {
        let NetworkURL = "\(baseURL)/album/\(album_id)/tracks"
        AF.request(NetworkURL, method: .get).responseDecodable(of: AlbumSongResponse.self) {
            response in completion(response.result)
        }
    }
    
    func getTrack(track_id: Int, completion: @escaping (Result<TrackResponse, AFError>) -> Void) {
        print(track_id)
        let NetworkURL = "\(baseURL)/track/\(track_id)"
        AF.request(NetworkURL, method: .get).responseDecodable(of: TrackResponse.self) {
            response in completion(response.result)
        }
    }
}
