//
//  ArtistsViewController.swift
//  DeezerClone
//
//  Created by Münevver Elif Ay on 13.05.2023.
//

import UIKit
import Alamofire

class ArtistsViewController: UIViewController {
    @IBOutlet weak var artistsCollectionView: UICollectionView!
//    var artists = [Artist]()
    var genreID: Int?
    var genreName: String?
    var artistResult = [Artist]()

    override func viewDidLoad() {
        super.viewDidLoad()
        artistsCollectionView.dataSource = self
        artistsCollectionView.delegate = self
        artistsCollectionView.register(UINib(nibName: String(describing: ArtistsCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ArtistsCell.self))
        artistsCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        
        // MARK: NavigationController
        title = genreName
        configureNavigation()
        
        configurebackground()
        configureArtists(genreId: genreID) { res in
            self.updateUI(results: res)
        }
    }
    private func configureArtists(genreId: Int?, completion: @escaping ([Artist]) -> Void) {
        NetworkService.sharedNetwork.getArtists(genre_id: genreId ?? 0) { artistResult in
            switch artistResult {
            case .success(let artistResponse):
                DispatchQueue.main.async {
                    self.artistResult = artistResponse.data ?? [Artist]()
//                    self.artistsCollectionView.reloadData()
                    guard let results = artistResponse.data else {
                        return
                    }
                    
                completion(results)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func updateUI(results: [Artist]) {
        DispatchQueue.main.async {
            GlobalDataManager.sharedGlobalManager.artistResults = results
            self.artistsCollectionView.reloadData()
        }
    }
    
    func selectDataCheck(indexPath: IndexPath, collectionView: UICollectionView) {
        
        DispatchQueue.main.async {
            GlobalDataManager.sharedGlobalManager.artistId = nil
            GlobalDataManager.sharedGlobalManager.artistSelectedIndexPath = indexPath
            self.artistsCollectionView.reloadData()
        }
    }
    
     func configureArtistDetail(artistId: Int?, completion: @escaping(ArtistDetailResponse) -> Void) { //ArtistDetailViewController'da seçilen artistin bilgilerini almak için
         NetworkService.sharedNetwork.getArtistDetail(artist_id: artistId ?? 0) { artistDetailResult in
                switch artistDetailResult {
                case .success(let artistDetailResponse):
                    DispatchQueue.main.async {
                        completion(artistDetailResponse)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
}
extension ArtistsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artistResult.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let artistsCell = artistsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ArtistsCell.self), for: indexPath) as? ArtistsCell else {
            return UICollectionViewCell()
        }
        
        artistsCell.layer.cornerRadius = 30
        artistsCell.layer.applySketchShadow(color: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5), alpha: 0.7, x: 1, y: 4, blur: 8, spread: 0)
 

       
        artistsCell.artistsName.text = GlobalDataManager.sharedGlobalManager.artistResults?[indexPath.item].name

        let artist = GlobalDataManager.sharedGlobalManager.artistResults?[indexPath.item]
        artistsCell.artistsImage.image = UIImage(named: artist?.picture_medium ?? "")
        artistsCell.artistsImage.kf.setImage(
            with: URL(string: "\(artist?.picture_xl ?? "")"),
            placeholder: nil,
            options: [.transition(.fade(0.7))]
        )

        return artistsCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        configureArtistDetail(artistId: GlobalDataManager.sharedGlobalManager.artistResults?[indexPath.item].id) { ArtistDetailResponse in
            if let artistsDetailVC =  self.storyboard?.instantiateViewController(withIdentifier: "ArtistDetailViewController") as? ArtistDetailViewController{
                
                let artistName = GlobalDataManager.sharedGlobalManager.artistResults?[indexPath.item].name
                artistsDetailVC.artistName = artistName
                
                let artistCover = GlobalDataManager.sharedGlobalManager.artistResults?[indexPath.item].picture_xl
                artistsDetailVC.artistCover = artistCover
                
                let artistId = GlobalDataManager.sharedGlobalManager.artistResults?[indexPath.item].id
                artistsDetailVC.artistId = artistId
                
                GlobalDataManager.sharedGlobalManager.artistId = GlobalDataManager.sharedGlobalManager.artistResults?[indexPath.item].id
                self.selectDataCheck(indexPath: indexPath, collectionView: collectionView)
            

                self.navigationController?.pushViewController(artistsDetailVC, animated: true)
            }
        }
    }
}

extension ArtistsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164, height: 189)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    }
}

