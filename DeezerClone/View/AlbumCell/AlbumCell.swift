//
//  AlbumCell.swift
//  DeezerClone
//
//  Created by Münevver Elif Ay on 13.05.2023.
//

import UIKit

class AlbumCell: UICollectionViewCell {

    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumReleaseDateLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        albumImageView.layer.cornerRadius = 30
        self.layer.cornerRadius = 30
        
        self.layer.applySketchShadow(color: UIColor.black, alpha: 0.2, x: 1, y: 4, blur: 8, spread: 0)

    }

}
