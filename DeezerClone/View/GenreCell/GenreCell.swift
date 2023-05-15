//
//  GenreCell.swift
//  DeezerClone
//
//  Created by Münevver Elif Ay on 13.05.2023.
//

import UIKit

class GenreCell: UICollectionViewCell {
    
    @IBOutlet weak var genreBackgroundView: UIView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var genreView: UIView!
    @IBOutlet weak var genreImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        genreView.layer.cornerRadius = 30
        genreImageView.layer.cornerRadius = 30
        
        genreView.layer.applySketchShadow(color: UIColor.black, alpha: 0.2, x: 1, y: 4, blur: 8, spread: 0)
  
        
    }
}
