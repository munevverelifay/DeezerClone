////
////  SongCell.swift
////  DeezerClone
////
////  Created by Münevver Elif Ay on 13.05.2023.
////
//
//import UIKit
//import CoreData
//
//class SongCell: UICollectionViewCell {
//
//    @IBOutlet weak var songView: UIView!
//    @IBOutlet weak var songNameLabel: UILabel!
//    @IBOutlet weak var songTimeLabel: UILabel!
//    @IBOutlet weak var songImageView: UIImageView!
//    @IBOutlet weak var songLikeImageView: UIImageView!
//    @IBOutlet weak var playImageView: UIImageView!
//
//    var songId: Int = 0
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//
//        songView.layer.cornerRadius = 30
//
//        self.layer.applySketchShadow(color: UIColor.black, alpha: 0.2, x: 1, y: 4, blur: 8, spread: 0)
//        songImageView.layer.cornerRadius = 30
//
//        let tapLikeGesture = UITapGestureRecognizer(target: self, action: #selector(likeIVTapped))
//
//        configureTouchableIV(iv: songLikeImageView, gestrue: tapLikeGesture)
//    }
//
//    @objc func likeIVTapped() {
//        songLikeImageView.image = UIImage(systemName: "heart.fill")
//
//
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "FavoriteTrackData", in: managedContext)!
//        let item = NSManagedObject(entity: entity, insertInto: managedContext)
//        item.setValue(songId, forKey: "trackId")
//        do{
//            GlobalDataManager.sharedGlobalManager.likeSongId?.append(songId)
//            print(GlobalDataManager.sharedGlobalManager.likeSongId ?? 0)
//            try managedContext.save()
//            print(songId)
//            print(item)
//        } catch let error{
//            print("Item can't be created: \(error.localizedDescription)")
//            //            GlobalDataManager.sharedGlobalManager.likeSongId?.remove(at: songId)
//        }
//    }
//
//}
//
//extension UICollectionViewCell {
//    func configureTouchableIV(iv: UIImageView?,
//                                  gestrue: UITapGestureRecognizer?) {
//            if let checkedIV = iv {
//                if let checkedGesture = gestrue {
//                    checkedIV.addGestureRecognizer(checkedGesture)
//                }
//                checkedIV.isUserInteractionEnabled = true
//            }
//        }
//}

import UIKit
import CoreData

class SongCell: UICollectionViewCell {

    @IBOutlet weak var songView: UIView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var songTimeLabel: UILabel!
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songLikeImageView: UIImageView!
    @IBOutlet weak var playImageView: UIImageView!

    var songId: Int = 0
    var isLiked: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        songView.layer.cornerRadius = 30

        self.layer.applySketchShadow(color: UIColor.black, alpha: 0.2, x: 1, y: 4, blur: 8, spread: 0)
        songImageView.layer.cornerRadius = 30

        let tapLikeGesture = UITapGestureRecognizer(target: self, action: #selector(likeIVTapped))
        configureTouchableIV(iv: songLikeImageView, gesture: tapLikeGesture)
    }

//    @objc func likeIVTapped() {
//        if isLiked {
//            songLikeImageView.image = UIImage(systemName: "heart")
//            GlobalDataManager.sharedGlobalManager.likeSongId?.removeAll(where: { $0 == songId })
//        } else {
//            songLikeImageView.image = UIImage(systemName: "heart.fill")
//            GlobalDataManager.sharedGlobalManager.likeSongId?.append(songId)
//        }
//
//        isLiked.toggle()
//
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "FavoriteTrackData", in: managedContext)!
//        let item = NSManagedObject(entity: entity, insertInto: managedContext)
//        item.setValue(songId, forKey: "trackId")
//        do {
//            try managedContext.save()
//            print(songId)
//            print(item)
//        } catch let error {
//            print("Item can't be created: \(error.localizedDescription)")
//        }
//    }
    
    @objc func likeIVTapped() {
        isLiked.toggle()

        if isLiked {
            songLikeImageView.image = UIImage(systemName: "heart.fill")
            saveFavoriteTrack()
        } else {
            songLikeImageView.image = UIImage(systemName: "heart")
            removeFavoriteTrack()
        }
    }

    func saveFavoriteTrack() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Entity1", in: managedContext)!

        let favoriteTrack = NSManagedObject(entity: entity, insertInto: managedContext)
        
        favoriteTrack.setValue(songId, forKey: "trackId")

        do {
            try managedContext.save()
        } catch let error {
            print("Failed to save favorite track: \(error.localizedDescription)")
        }
    }

    func removeFavoriteTrack() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity1")
        fetchRequest.predicate = NSPredicate(format: "trackId == %d", songId)

        do {
            let fetchResults = try managedContext.fetch(fetchRequest)
            if let favoriteTrack = fetchResults.first as? NSManagedObject {
                managedContext.delete(favoriteTrack)
                try managedContext.save()

                if let index = GlobalDataManager.sharedGlobalManager.favoriteSongId?.firstIndex(of: songId) {
                    GlobalDataManager.sharedGlobalManager.favoriteSongId?.remove(at: index)
                    print(GlobalDataManager.sharedGlobalManager.favoriteSongId)
                }
            }
        } catch let error {
            print("Failed to remove favorite track: \(error.localizedDescription)")
        }
    }

}

extension UICollectionViewCell {
    func configureTouchableIV(iv: UIImageView?, gesture: UITapGestureRecognizer?) {
        if let checkedIV = iv {
            if let checkedGesture = gesture {
                checkedIV.addGestureRecognizer(checkedGesture)
            }
            checkedIV.isUserInteractionEnabled = true
        }
    }
}
