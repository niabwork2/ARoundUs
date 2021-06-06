//
//  GalleryTableViewController.swift
//  ARoundUs
//
//  Created by niab on Jun/06/21.
//

import UIKit

class GalleryTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var galleryAPIArray = [memes]()
    
    func createArray() -> [memes] {
        
        if UserProfileCache.get() == nil {
            UserProfileCache.save(galleryAPIArray)
            galleryAPIArray = UserProfileCache.get() ?? []
            print("galleryAPIArray from userDefault first: \(galleryAPIArray)")
            print("galleryAPIArray items first: \(galleryAPIArray.count)")

            print("add image first")

            return galleryAPIArray

        } else {

            galleryAPIArray = UserProfileCache.get() ?? []
            print("galleryAPIArray from userDefault: \(galleryAPIArray)")
            print("galleryAPIArray items: \(galleryAPIArray.count)")

            print("galleryAPIArray ready for AR: \(galleryAPIArray)")

            return galleryAPIArray
        }
        
        
//        let gallery1 = memes(name: "test", details: "test", imageData: (UIImage(named: "nah")?.pngData())!)
//        galleryAPIArray.append(gallery1)
//
//        print(galleryAPIArray)
//
//        return galleryAPIArray
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       

        galleryAPIArray = createArray()
        self.navigationItem.title = "All gallery items: \(galleryAPIArray.count)"
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        galleryAPIArray = createArray()
        tableView.reloadData()
    }
    
    

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension GalleryTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return galleryAPIArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let gallery = galleryAPIArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell") as! GalleryCell
        
        cell.setGallery(gallery: gallery)
        
        return cell
    }
}
