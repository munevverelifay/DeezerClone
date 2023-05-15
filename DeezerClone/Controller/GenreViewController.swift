//
//  GenreViewController.swift
//  DeezerClone
//
//  Created by Münevver Elif Ay on 13.05.2023.
//

import UIKit
import Kingfisher
import CoreData

class GenreViewController: UIViewController {
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var tabBar: UITabBarItem!
    var genres = [Genre]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genreCollectionView.dataSource = self
        genreCollectionView.delegate = self
        genreCollectionView.register(UINib(nibName: String(describing: GenreCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: GenreCell.self))
        genreCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        
        configureNavigation()
        navigationController?.navigationBar.topItem?.title = "Kategoriler"

        configurebackground()
        getGenres()
        fetchItems()
        print(GlobalDataManager.sharedGlobalManager.favoriteSongId)
    }
    
    private func getGenres(){
        NetworkService.sharedNetwork.getGenres { data in
            switch data {
            case .success(let genres):
                DispatchQueue.main.async {
                    self.genres = genres.data ?? [Genre]()
                    self.genreCollectionView.reloadData()
                }
            case .failure(let genresError):
                print(genresError)
            }
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

extension GenreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let genreCell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GenreCell.self), for: indexPath) as? GenreCell else {
            return UICollectionViewCell()
        }

        
        genres.forEach { item in
            GlobalDataManager.sharedGlobalManager.genreId?.append(item.id ?? 0)
        }
        genreCell.genreLabel.text = genres[indexPath.item].name

        let genre = genres[indexPath.item]
        genreCell.genreImageView.image = UIImage(named: genre.picture_medium ?? "")
        genreCell.genreImageView.kf.setImage(
            with: URL(string: "\(genre.picture_xl ?? "")"),
            placeholder: nil,
            options: [.transition(.fade(0.7))]
        )


        return genreCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let artistsVC =  storyboard?.instantiateViewController(withIdentifier: "ArtistsViewController") as? ArtistsViewController{
            let genre = GlobalDataManager.sharedGlobalManager.genreId?[indexPath.item]
            artistsVC.genreID = genre
            
            let genreName = genres[indexPath.item].name
            artistsVC.genreName = genreName

            self.navigationController?.pushViewController(artistsVC, animated: true)
        }
//        if indexPath.row == 3 { // 3. hücre seçildiğinde
//            if let productDetailVC = storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as? ProductViewController {
//                navigationController?.pushViewController(productDetailVC, animated: true)
//            }
//        }
    }
}

extension GenreViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164, height: 199)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    }
}
