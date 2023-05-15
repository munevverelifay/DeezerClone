//
//  AlbumViewController.swift
//  DeezerClone
//
//  Created by Münevver Elif Ay on 13.05.2023.
//

import UIKit
import Kingfisher
import AVFoundation
import CoreData

class AlbumViewController: UIViewController {
    @IBOutlet weak var songCollectionView: UICollectionView!
    var player: AVAudioPlayer!
    var albumId: Int?
    var albumName: String?
    var songs = [AlbumSongDetails]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        songCollectionView.dataSource = self
        songCollectionView.delegate = self
        songCollectionView.register(UINib(nibName: String(describing: SongCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: SongCell.self))
        songCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        configurebackground()
        
        title = albumName
        configureNavigation()
        
        configureAlbum(albumId: albumId) { res in
            self.albumUpdateUI(results: res)
        }
    
       
    }
        
    private func configureAlbum(albumId: Int?, completion: @escaping ([AlbumSongDetails]) -> Void) {

        NetworkService.sharedNetwork.getAlbum(album_id: albumId ?? 0) { AlbumResult in
            switch AlbumResult {
            case .success(let AlbumResponse):
                DispatchQueue.main.async {
                    self.songs = AlbumResponse.data
                    self.songCollectionView.reloadData()
                    print(AlbumResponse)
                    
                    let results = AlbumResponse.data
                  completion(results)
                    
                print("AlbumResponse.data is nil")
                }
            case .failure(let genresError):
                print(genresError)
            }
        }
    }
    func albumUpdateUI(results: [AlbumSongDetails]) {
        DispatchQueue.main.async {
            GlobalDataManager.sharedGlobalManager.songResults = results
            print(results)
            self.songCollectionView.reloadData()
        }
    }
    
    func albumSelectDataCheck(indexPath: IndexPath, collectionView: UICollectionView) {
        
        DispatchQueue.main.async {
//            GlobalDataManager.sharedGlobalManager.songId = nil
//            GlobalDataManager.sharedGlobalManager.songSelectedIndexPath = indexPath
            self.songCollectionView.reloadData()
        }
    }
    
    func fetchFavoriteTracks() {
        GlobalDataManager.sharedGlobalManager.favoriteSongId = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity1")
        
        do {
            let fetchResults = try managedContext.fetch(fetchRequest)

             for item in fetchResults as! [NSManagedObject] {
                 if let trackId = item.value(forKey: "trackId") as? Int {
                     GlobalDataManager.sharedGlobalManager.favoriteSongId?.append(trackId)
                     print(GlobalDataManager.sharedGlobalManager.favoriteSongId)
                 }
             }
        } catch {
            
        }
    }
    
}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let songCell = songCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SongCell.self), for: indexPath) as? SongCell else {
            return UICollectionViewCell()
        }
        
        songCell.songImageView.kf.setImage(with: URL(string: GlobalDataManager.sharedGlobalManager.artistAlbumImage ?? ""))
        songCell.songNameLabel.text = songs[indexPath.item].title
        let seconds = songs[indexPath.item].duration
        let minutes = seconds / 60
        songCell.songTimeLabel.text = "\(minutes): \(seconds % 60)''"
        
        
//        if let likeSongIdArray = GlobalDataManager.sharedGlobalManager.likeSongId {
//            if likeSongIdArray.contains(songs[indexPath.item].id) {
//                songCell.songLikeImageView.image = UIImage(systemName: "heart.fill")
//            } else {
//                songCell.songLikeImageView.image = UIImage(systemName: "heart")
//            }
//        }
//
//        songCell.songId = songs[indexPath.item].id
//

        songCell.songId = songs[indexPath.item].id

        if let favoriteSongIds = GlobalDataManager.sharedGlobalManager.favoriteSongId,
           favoriteSongIds.contains(songs[indexPath.item].id) {
            songCell.songLikeImageView.image = UIImage(systemName: "heart.fill")
            songCell.isLiked = true
        } else {
            songCell.songLikeImageView.image = UIImage(systemName: "heart")
            songCell.isLiked = false
        }

        return songCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        guard let cell = collectionView.cellForItem(at: indexPath) as? SongCell else {
//            return
//        }
//        cell.playImageView.image = UIImage(systemName: "play.fill")
//
//
//
//        GlobalDataManager.sharedGlobalManager.songId = GlobalDataManager.sharedGlobalManager.songResults?[indexPath.item].id
        
        self.albumSelectDataCheck(indexPath: indexPath, collectionView: collectionView)
        
        let songPreview = songs[indexPath.item].preview
         print(songPreview)
         
        if let player = self.player {
            if player.isPlaying {
                player.stop()
                return
            }
        }
        playSound(soundUrl: songPreview)
        
//        collectionView.reloadData()
    }
    
    func playSound(soundUrl: String) {
        guard let url = URL(string: soundUrl) else {
            print("Error: Invalid URL")
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    do {
                        self.player = try AVAudioPlayer(data: data)
                        self.player.play()
                    } catch {
                        print("Error playing sound: \(error.localizedDescription)")
                    }
                }
            } catch {
                print("Error loading sound data: \(error.localizedDescription)")
            }
        }
    }
    
}

extension AlbumViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 364, height: 130)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    }
}
