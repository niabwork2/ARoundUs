//
//  GalleryCell.swift
//  ARoundUs
//
//  Created by niab on Jun/06/21.
//

import UIKit
import SwipeCellKit

class GalleryCell: SwipeTableViewCell {

    @IBOutlet weak var galleryImageView: UIImageView!
    @IBOutlet weak var galleryTitle: UILabel!
    @IBOutlet weak var gallerySubtitle: UILabel!
    
    func setGallery(gallery: memes) {
        galleryImageView.image = UIImage(data: gallery.imageData)
  
        galleryImageView.layer.borderWidth = 2
        galleryImageView.layer.borderColor = UIColor.systemGray.cgColor
        galleryImageView.layer.cornerRadius = 20
       
        
        galleryTitle.text = gallery.name
        gallerySubtitle.text = gallery.details
    }
 
    
}
