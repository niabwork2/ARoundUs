//
//  GalleryTableViewController.swift
//  ARoundUs
//
//  Created by niab on Jun/06/21.
//

import UIKit
import SwipeCellKit

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
        //print(NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true) .last! as String)
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
        
        print(dataFilePath!)

        galleryAPIArray = createArray()
        
        DispatchQueue.main.async {
            self.navigationItem.title = "All gallery items: \(self.galleryAPIArray.count)"
        }
      
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        galleryAPIArray = createArray()
        tableView.reloadData()
        DispatchQueue.main.async {
        self.navigationItem.title = "All gallery items: \(self.galleryAPIArray.count)"
        }
    }
    

     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard tableView.indexPathForSelectedRow != nil else {
            return
        }
        
        let selectedRow = galleryAPIArray[tableView.indexPathForSelectedRow!.row]
        let galleryDetailVC = segue.destination as! GalleryDetailViewController
        galleryDetailVC.gallery = selectedRow
        
     }
     
    
}

// MARK: - TableView Stuff
extension GalleryTableViewController: UITableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return galleryAPIArray.count
    }
    
    // MARK: - SwipeTableViewCell
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let gallery = galleryAPIArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell") as! GalleryCell
        
        cell.delegate = self
        
        cell.setGallery(gallery: gallery)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [self] action, indexPath in
            // handle action by updating model with deletion
            print("Item deleted: \(self.galleryAPIArray[indexPath.row])")
            UserProfileCache.remove(arrayIndex: indexPath.row)
            
            createArray()
            
            DispatchQueue.main.async {
                self.navigationItem.title = "All gallery items: \(self.galleryAPIArray.count)"
            }
            
            tableView.reloadData()
         
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
}
