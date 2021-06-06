//
//  AddImageVCSegue.swift
//  ARoundUs
//
//  Created by niab on Jun/06/21.
//

import UIKit



class AddImageVCSegue: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, InformingDelegate  {
    var worldVC = ViewController()
    
    var galleryAPIArray = [memes]()
    
    func valueChanged() -> [memes] {
        return galleryAPIArray
    }
    
    
    
    
    
    var userTitlePassed: String?
    var userSubtitlePassed: String?
    var userImagePassed: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleTf: UITextField!
    @IBOutlet weak var subTitleTf: UITextField!
    
    @IBOutlet weak var okButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        worldVC.delegate = self
        
        
        self.hideKeyboardWhenTappedAround()
        
        imageView.image = nil
        
        if imageView.image == nil {
            okButton.isEnabled = false
            okButton.backgroundColor = UIColor.systemGray5
            imageView.layer.borderWidth = 0
            titleTf.text = ""
            subTitleTf.text = ""
        }
        
        okButton.layer.cornerRadius = 10
        okButton.layer.shadowColor = UIColor.systemGray.cgColor
        okButton.layer.shadowOpacity = 0.8
        okButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        okButton.layer.borderWidth = 2
        okButton.layer.borderColor = UIColor.systemGray.cgColor
        
        
    }
    
    @IBAction func onOkButton(_ sender: Any) {
        
        userTitlePassed = titleTf.text
        userSubtitlePassed =  subTitleTf.text
        userImagePassed = imageView.image
        
        if UserProfileCache.get() == nil {
            print("add image first")
            
            let gallery = memes(name: userTitlePassed ?? "",details: userSubtitlePassed ?? "", imageData: (userImagePassed?.jpegData(compressionQuality: 0))!)
            galleryAPIArray.append(gallery)
            print("galleryAPIArray from AddImageVC: \(galleryAPIArray)")
            print("galleryAPIArray items: \(galleryAPIArray.count)")
            
            worldVC.callFromOtherClass()
            
        } else {
            galleryAPIArray =  UserProfileCache.get() ?? []
            print("galleryAPIArray from userDefault: \(galleryAPIArray)")
            print("galleryAPIArray items: \(galleryAPIArray.count)")
            
            let gallery = memes(name: userTitlePassed ?? "",details: userSubtitlePassed ?? "", imageData: (userImagePassed?.jpegData(compressionQuality: 0))!)
            galleryAPIArray.append(gallery)
            print("galleryAPIArray from AddImageVC: \(galleryAPIArray)")
            print("galleryAPIArray items: \(galleryAPIArray.count)")
            
            worldVC.callFromOtherClass()
            
        }
        
        let alert = UIAlertController(title: "Add Image to Gallery", message: "\(titleTf.text ?? "Title") added to gallery ", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) in self.viewDidLoad()}))
        self.present(alert, animated: true)
        
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Add Image", message: "Choose a image", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                imagePickerController.allowsEditing = true
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                print("Camera not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let userImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        print("User pick this image: \(userImage)")
        
        imageView?.image = userImage
        
        userImagePassed = userImage
        
        okButton.isEnabled = true
        okButton.backgroundColor = UIColor.systemGreen
        okButton.layer.borderColor = UIColor.systemGreen.cgColor
        
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.layer.cornerRadius = 40
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    

}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

struct UserProfileCache {
    static let key = "userProfileCache"
    static func save(_ value: [memes]!) {
         UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: key)
        print("Saved data in UserDefaults")
    }
    static func get() -> [memes]? {
        var userData: [memes]?
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            userData = try? PropertyListDecoder().decode([memes].self, from: data)
            print("Load data from UserDefaults")
            return userData!
        } else {
            print("Load data from UserDefaults")
            return userData
        }
    }
    static func remove() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
