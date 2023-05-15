//
//  ArtistDetailViewController.swift
//  DeezerClone
//
//  Created by Münevver Elif Ay on 13.05.2023.
//

import UIKit

class ArtistDetailViewController: UIViewController {
    @IBOutlet weak var artistsImageView: UIImageView!
    @IBOutlet weak var albumCollectionView: UICollectionView!
    var artistId: Int?
    var artistName: String?
    var artistCover: String?

    var artist = [ArtistDetail]()
    var albums = [AlbumDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumCollectionView.dataSource = self
        albumCollectionView.delegate = self
        albumCollectionView.register(UINib(nibName: String(describing: AlbumCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: AlbumCell.self))
        albumCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        artistsImageView.layer.cornerRadius = 30
        
        // MARK: NavigationController
        title = artistName
        configureNavigation()
        
        
        configurebackground()
        configureArtistAlbums(artistId: artistId) { res in
            self.artistAlbumUpdateUI(results: res)
        }
        
        let imageUrl = URL(string: artistCover ?? "")
        
        artistsImageView.kf.setImage(with: imageUrl, placeholder: nil, options: [.transition(.fade(0.2))], completionHandler: { result in
            switch result {
            case .success(_):
                // Image was successfully downloaded and set
                // Apply aspect fill content mode
                self.artistsImageView.contentMode = .scaleToFill
                self.artistsImageView.clipsToBounds = true
            case .failure(let error):
                // Handle error
                print("Error: \(error)")
            }
        })

    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureArtistAlbums(artistId: artistId) { res in
            self.artistAlbumUpdateUI(results: res)
        }
    }
    
    private func configureArtistAlbums(artistId: Int?, completion: @escaping ([AlbumDetail]) -> Void) {
        NetworkService.sharedNetwork.getArtistAlbum(artist_id: artistId ?? 0) { artistAlbumResult in
            switch artistAlbumResult {
            case .success(let artistAlbumResponse):
                DispatchQueue.main.async {
                    self.albums = artistAlbumResponse.data ?? [AlbumDetail]()
                    
                    guard let results = artistAlbumResponse.data else {
                        return
                    }
                  completion(results)
                }
            case .failure(let genresError):
                print(genresError)
            }
        }
    }
    
    func artistAlbumUpdateUI(results: [AlbumDetail]) {
        DispatchQueue.main.async {
            GlobalDataManager.sharedGlobalManager.albumResults = results
            self.albumCollectionView.reloadData()
        }
    }
    
    func artistAlbumSelectDataCheck(indexPath: IndexPath, collectionView: UICollectionView) {
        
        DispatchQueue.main.async {
            GlobalDataManager.sharedGlobalManager.albumId = nil
            GlobalDataManager.sharedGlobalManager.albumSelectedIndexPath = indexPath
            self.albumCollectionView.reloadData()
        }
    }
    
}
extension ArtistDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        guard let albumsCell = albumCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AlbumCell.self), for: indexPath) as? AlbumCell else {
            return UICollectionViewCell()
        }
        
        if let albumResults = GlobalDataManager.sharedGlobalManager.albumResults, indexPath.item < albumResults.count {
            
            albumsCell.albumNameLabel.text = GlobalDataManager.sharedGlobalManager.albumResults?[indexPath.item].title

            albumsCell.albumReleaseDateLabel.text = GlobalDataManager.sharedGlobalManager.albumResults?[indexPath.item].release_date
            
            let artistAlbums = GlobalDataManager.sharedGlobalManager.albumResults?[indexPath.item].cover_xl ?? ""
            albumsCell.albumImageView.kf.setImage(with: URL(string: artistAlbums))
             
         }
    

        return albumsCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        configureArtistAlbums(artistId: GlobalDataManager.sharedGlobalManager.albumResults?[indexPath.item].id) { ArtistAlbumResponse in
            if let artistsAlbumVC =  self.storyboard?.instantiateViewController(withIdentifier: "AlbumViewController") as? AlbumViewController{
                
                let albumId = GlobalDataManager.sharedGlobalManager.albumResults?[indexPath.item].id
                artistsAlbumVC.albumId = albumId
                
                let albumName = GlobalDataManager.sharedGlobalManager.albumResults?[indexPath.item].title
                artistsAlbumVC.albumName = albumName
                
                let artistAlbumImage = GlobalDataManager.sharedGlobalManager.albumResults?[indexPath.item].cover_xl ?? ""
                GlobalDataManager.sharedGlobalManager.artistAlbumImage = artistAlbumImage
                

                GlobalDataManager.sharedGlobalManager.albumId = GlobalDataManager.sharedGlobalManager.albumResults?[indexPath.item].id
                self.artistAlbumSelectDataCheck(indexPath: indexPath, collectionView: collectionView)
                
                self.navigationController?.pushViewController(artistsAlbumVC, animated: true)
            }
        }
    }
}

extension ArtistDetailViewController: UICollectionViewDelegateFlowLayout {
    
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
