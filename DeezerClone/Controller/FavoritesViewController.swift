//
//  FavoritesViewController.swift
//  DeezerClone
//
//  Created by Münevver Elif Ay on 14.05.2023.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    var tracks = [TrackResponse]()
    var trres = [TrackResponse]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.delegate = self
        favoritesCollectionView.register(UINib(nibName: String(describing: SongCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: SongCell.self))
        favoritesCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        configurebackground()
        
        
        title = "Beğenilenler"
        configureNavigation()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchItems()
        favoritesCollectionView.reloadData()
    }
    
    private func configureTrack(trackId: Int?, completion: @escaping ([TrackResponse]) -> Void) {
        
        NetworkService.sharedNetwork.getTrack(track_id: trackId ?? 0) { TrackResult in
            switch TrackResult {
            case .success(let TrackResponse):
                DispatchQueue.main.async {
                    self.tracks = [TrackResponse]
                    self.trres.append(TrackResponse)
                    self.favoritesCollectionView.reloadData()
                    print(TrackResponse)
                    let results = [TrackResponse]
                    completion(results)
                    
                    print("TrackResponse.data is nil")
                }
            case .failure(let tracksError):
                print(tracksError)
            }
        }
    }
    func trackUpdateUI(results: [TrackResponse]) {
        DispatchQueue.main.async {
            GlobalDataManager.sharedGlobalManager.trackResults?.append(contentsOf: results)
            print(results)
            self.favoritesCollectionView.reloadData()
        }
    }
    
    func trackSelectDataCheck(indexPath: IndexPath, collectionView: UICollectionView) {
        
        DispatchQueue.main.async {
            GlobalDataManager.sharedGlobalManager.trackId = nil
            self.favoritesCollectionView.reloadData()
        }
    }
    
    func fetchItems(){
        GlobalDataManager.sharedGlobalManager.favoriteSongId?.removeAll(keepingCapacity: false)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity1")
        
        do {
            let fetchResults = try managedContext.fetch(fetchRequest)
            
            for item in fetchResults as! [NSManagedObject]{
                
                GlobalDataManager.sharedGlobalManager.favoriteSongId?.append(item.value(forKey: "trackId") as? Int ?? 0)
                
            }
            
        } catch let error{
            print(error.localizedDescription)
        }
    }
   
    
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GlobalDataManager.sharedGlobalManager.favoriteSongId?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let favoritesCell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SongCell.self), for: indexPath) as? SongCell else {
            return UICollectionViewCell()
        }
        configureTrack(trackId: GlobalDataManager.sharedGlobalManager.favoriteSongId?[indexPath.item]) { res in
            self.trackUpdateUI(results: res)
        }
        
        GlobalDataManager.sharedGlobalManager.trackId?.append(GlobalDataManager.sharedGlobalManager.favoriteSongId![indexPath.item])

        
        if let trackResults = GlobalDataManager.sharedGlobalManager.trackResults, indexPath.item < trackResults.count {
            
            favoritesCell.songNameLabel.text = GlobalDataManager.sharedGlobalManager.trackResults?[indexPath.item].title

            favoritesCell.songId = GlobalDataManager.sharedGlobalManager.trackResults?[indexPath.item].id ?? 0
            
            if let favoriteSongIds = GlobalDataManager.sharedGlobalManager.favoriteSongId,
               favoriteSongIds.contains(GlobalDataManager.sharedGlobalManager.trackResults?[indexPath.item].id ?? 0) {
                favoritesCell.songLikeImageView.image = UIImage(systemName: "heart.fill")
                favoritesCell.isLiked = true
            } else {
                favoritesCell.songLikeImageView.image = UIImage(systemName: "heart")
                favoritesCell.isLiked = false
            }
         }
        

        
        return favoritesCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    
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
