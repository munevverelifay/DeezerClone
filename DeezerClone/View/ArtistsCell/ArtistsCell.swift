//
//  ArtistsCell.swift
//  DeezerClone
//
//  Created by Münevver Elif Ay on 13.05.2023.
//

import UIKit

class ArtistsCell: UICollectionViewCell {

    @IBOutlet weak var artistsImage: UIImageView!
    @IBOutlet weak var artistsName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        artistsImage.layer.cornerRadius = artistsImage.frame.height / 2
       

        
        
        

    }

}
