//
//  GalleryCell.swift
//  ARoundUs
//
//  Created by niab on Jun/06/21.
//

import UIKit

class GalleryCell: UITableViewCell {

    @IBOutlet weak var galleryImageView: UIImageView!
    @IBOutlet weak var galleryTitle: UILabel!
    @IBOutlet weak var gallerySubtitle: UILabel!
    
    func setGallery(gallery: memes) {
        galleryImageView.image = UIImage(data: gallery.imageData)
        galleryImageView.layer.cornerRadius = 10
        
        
        galleryTitle.text = gallery.name
        gallerySubtitle.text = gallery.details
    }
 
    
}
