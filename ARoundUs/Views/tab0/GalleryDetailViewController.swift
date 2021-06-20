//
//  GalleryDetailViewController.swift
//  ARoundUs
//
//  Created by niab on Jun/20/21.
//

import UIKit

class GalleryDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    var gallery = memes(name: "", details: "", imageData: Data(), date: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        
        imageView.image =  UIImage(data: self.gallery.imageData)
        
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.layer.cornerRadius = 40
        
        titleLabel.text = gallery.name
        subtitleLabel.text = gallery.details
        
        noteLabel.text = "item note"
        
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "E, d MMM yyyy HH:mm:ss"
        dateLabel.text =  format.string(from: gallery.date)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
       
        //        let format = DateFormatter()
        //        format.timeZone = .current
        //        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        //        let dateString = format.string(from: currentDate)
        
//        let df = DateFormatter()
//        df.dateFormat = "EEEE, MMM d, yyyy"
//        self.dateLabel.text = df.string(from: memes.details)
        
//        guard memes.self != nil else {
//            return
//        }
        
        
    }
    

}
