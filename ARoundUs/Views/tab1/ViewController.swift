//
//  ViewController.swift
//  ARoundUs
//
//  Created by niab on Mar/21/21.
//

import UIKit
import SceneKit
import ARKit

protocol InformingDelegate {
    func valueChanged() -> [memes]
}

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    
    var delegate: InformingDelegate?
    
    var galleryAPIArray = [memes]()
    
    let userDefaults = UserDefaults.standard
   
    
    func callFromOtherClass() {
        galleryAPIArray = self.delegate?.valueChanged() ?? [memes]()
        print("galleryAPIArray from ViewController: \(galleryAPIArray)")
        UserProfileCache.save(galleryAPIArray)
    }
   
    func sendData(dataArray: [memes], completion: ([memes])->([memes])) {
        
    }
    
    func getData(dataArray: [memes]) -> [memes] {
        return dataArray
    }
    
    var configuration = ARImageTrackingConfiguration()
    @IBOutlet weak var imageView: UIImageView!
    
    //var memesAPIArray = [memes]()
    //var memesImageArray: Array<Any> = []
    
    
    //var galleryAPIArray = [memes]()
    //var galleryImageArray: Array<Any> = []
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        

        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Fetch JSON from API
        //        let urlString = "https://api.imgflip.com/get_memes"
        //
        //        if let url = URL(string: urlString) {
        //            if let data = try? Data(contentsOf: url) {
        //                parse(json: data)
        //                print("memesArray size: \(memesAPIArray.count)")
        //            } else {
        //                showError()
        //            }
        //        }
        
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    //    func parse(json: Data) {
    //        let decoder = JSONDecoder()
    //
    //        if let jsonMemes = try? decoder.decode(GetMemes.self, from: json) {
    //            memesAPIArray = jsonMemes.data.memes
    //        }
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //        memesAPIArray.forEach { memes in
        //            memesImageArray.append(memes.url)
        //        }
        
        //        print(memesAPIArray.count)
        
        //        let memesSliceArray = Array(memesAPIArray[0 ..< 60])
        //
        //        print(memesSliceArray)
        //        addReferences(media: memesSliceArray)
     
        
        if UserProfileCache.get() == nil {
            UserProfileCache.save(galleryAPIArray)
            galleryAPIArray = UserProfileCache.get() ?? []
            print("galleryAPIArray from userDefault first: \(galleryAPIArray)")
            print("galleryAPIArray items first: \(galleryAPIArray.count)")
            
            print("add image first")
            
            
        } else {
        
        galleryAPIArray = UserProfileCache.get() ?? []
        print("galleryAPIArray from userDefault: \(galleryAPIArray)")
        print("galleryAPIArray items: \(galleryAPIArray.count)")
        
        print("galleryAPIArray ready for AR: \(galleryAPIArray)")
        
            
        }
        
        if sceneView != nil {
            addReferences2(media: galleryAPIArray)
        }
        
        // Create a session configuration
        //        self.configuration = ARImageTrackingConfiguration()
        //
        //        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "memeSet", bundle: Bundle.main) {
        //            configuration.trackingImages = trackedImages
        //            configuration.maximumNumberOfTrackedImages = 5
        //
        //            //print("Images found")
        //
        //        }
        //
        //        // Run the view's session
        //        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    fileprivate func addARnode(_ imageAnchor: ARImageAnchor, _ spriteKitScene: SKScene?, _ node: SCNNode) {
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width / 2, height: imageAnchor.referenceImage.physicalSize.height / 2)
        
        plane.cornerRadius = plane.width / 8
        plane.firstMaterial?.diffuse.contents = spriteKitScene
        plane.firstMaterial?.isDoubleSided = true
        plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi/2
        planeNode.position.z = -0.045
        planeNode.position.y = 0.05
        
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            //            let videoNode = SKVideoNode(fileNamed: "harrypotter.mp4")
            //            videoNode.play()
            //            let videoScene = SKScene(size: CGSize(width: 1080, height: 720))
            //            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            //            videoNode.yScale = -1.0
            //            videoScene.addChild(videoNode)
            //
            //
            //            if imageAnchor.referenceImage.name == "eevee-card" {
            //                let spriteKitScene = SKScene(fileNamed: "eevee")
            //                addARnode(imageAnchor, spriteKitScene, node)
            //            }
            //            else if imageAnchor.referenceImage.name == "oddish-card" {
            //                let spriteKitScene = SKScene(fileNamed: "oddish")
            //                addARnode(imageAnchor, spriteKitScene, node)
            //            }
            //memesAPIArray.forEach { memes in
            galleryAPIArray.forEach { eachItem in
                
                let spriteKitScene = SKScene(fileNamed: "MemeTemplate")
                let MemeName = spriteKitScene?.childNode(withName: "MemeName") as! SKLabelNode
                let MemeImage = spriteKitScene?.childNode(withName: "MemeImage") as! SKSpriteNode
                let MemeDetails = spriteKitScene?.childNode(withName: "MemeDetails") as! SKLabelNode
                let MemeDate = spriteKitScene?.childNode(withName: "MemeDate") as! SKLabelNode
                
                if imageAnchor.referenceImage.name == eachItem.name {
                    
                    MemeName.text = eachItem.name
                    MemeDetails.text = eachItem.details
                    
                    let format = DateFormatter()
                    format.timeZone = .current
                    format.dateFormat = "E, d MMM yyyy HH:mm:ss"
                    MemeDate.text =  format.string(from: eachItem.date)
                    
                    //let url = URL(string: memes.url)
                    //let data = try? Data(contentsOf: url!)
                    
                    let memeUIImage = UIImage(data: eachItem.imageData) //UIImage(data: data!)
                    let memeTexture = SKTexture(image: memeUIImage!)
                    
                    MemeImage.texture = memeTexture
                    //imageView.downloaded(from: memes.url)
                    
                    addARnode(imageAnchor, spriteKitScene, node)
                    
                } else {
                    
                    MemeName.text = "Meme not found"
                    MemeDetails.text = "Just Keep Memeing :)"
                    
                    let memeUIImage = UIImage(named: "nyan")
                    let memeTexture = SKTexture(image: memeUIImage!)
                    MemeImage.texture = memeTexture
                    
                    //addARnode(imageAnchor, spriteKitScene, node)
                    
                    
                }
                
            }
            
            //            switch imageAnchor.referenceImage.name {
            //
            //            case "square-Goryokaku":
            //                let spriteKitScene = SKScene(fileNamed: "Goryokaku")
            //                addARnode(imageAnchor, spriteKitScene, node)
            //
            //            case "square-Lake-Toya":
            //                let spriteKitScene = SKScene(fileNamed: "Lake-Toya")
            //                addARnode(imageAnchor, spriteKitScene, node)
            //
            //            case "square-Sapporo-Odori-Park":
            //                let spriteKitScene = SKScene(fileNamed: "Sapporo-Odori-Park")
            //                addARnode(imageAnchor, spriteKitScene, node)
            //
            //            case "square-Shiretoko-National-Park":
            //                let spriteKitScene = SKScene(fileNamed: "Shiretoko-National-Park")
            //                addARnode(imageAnchor, spriteKitScene, node)
            //
            //            case "square-Shirogane-Blue-Pond":
            //                let spriteKitScene = SKScene(fileNamed: "Shirogane-Blue-Pond")
            //                addARnode(imageAnchor, spriteKitScene, node)
            //
            //            default:
            //                break
            //            }
            
            
            
        }
        
        return node
    }
    
    //    func addReferences(media: Array<Any>){
    //        var customReferenceSet = Set<ARReferenceImage>()
    //        let imageFetchingGroup = DispatchGroup()
    //        for medium in media {
    ////            let type = (medium as AnyObject).value(forKey: "type");
    ////            _ = type as! String
    //
    //            //let reference = (medium as AnyObject).value(forKey: "url");
    //            //let ref = reference as! String
    //            let ref = medium as! memes
    //
    //            //let ide = (medium as AnyObject).value(forKey: "id");
    //            //let id = ide as! String
    //            let id = medium as! memes
    //
    //            let url = URL(string: ref.url)
    //            let session = URLSession(configuration: .default)
    //
    //            imageFetchingGroup.enter()
    //            let downloadPicTask = session.dataTask(with: url!) { (data, response, error) in
    //                if let e = error {
    //                    print("Error downloading picture: \(e)")
    //                    imageFetchingGroup.leave()
    //                } else {
    //                    if let res = response as? HTTPURLResponse {
    //                        print("Downloaded picture with response code \(res.statusCode)")
    //                        if let imageData = data {
    //                            let image = UIImage(data: imageData)!
    //
    //                            DispatchQueue.main.async {
    //                                //self.imageView.image = image
    //                                let arImage = ARReferenceImage(image.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.065)
    //
    //                                arImage.name = id.name
    //
    //                                customReferenceSet.insert(arImage)
    //                                print(arImage.name!)
    //                                print(customReferenceSet.count)
    //                            }
    //
    //
    //                            imageFetchingGroup.leave()
    //                        } else {
    //                            print("Couldn't get image: Image is nil")
    //                            imageFetchingGroup.leave()
    //                        }
    //                    } else {
    //                        print("Couldn't get response code for some reason")
    //                        imageFetchingGroup.leave()
    //                    }
    //                }
    //            }
    //
    //            downloadPicTask.resume()
    //        }
    //
    //        //        // Create a session configuration
    //        //        self.configuration = ARImageTrackingConfiguration()
    //        //
    //        //        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "memeSet", bundle: Bundle.main) {
    //        //            configuration.trackingImages = trackedImages
    //        //            configuration.maximumNumberOfTrackedImages = 5
    //        //
    //        //            //print("Images found")
    //        //
    //        //        }
    //        //
    //        //        // Run the view's session
    //        //        sceneView.session.run(configuration)
    //
    //        self.configuration = ARImageTrackingConfiguration()
    //        imageFetchingGroup.notify(queue: .main) {
    //            self.configuration.trackingImages = customReferenceSet
    //            self.configuration.maximumNumberOfTrackedImages = 5
    //            self.sceneView.session.run(self.configuration)
    //        }
    //    }
    
    func addReferences2(media: Array<Any>){
        var customReferenceSet = Set<ARReferenceImage>()
        let imageFetchingGroup = DispatchGroup()
        for medium in media {
            
            let id = medium as! memes
            
            imageFetchingGroup.enter()
            
            let image = UIImage(data: id.imageData)!
            
            DispatchQueue.main.async {
                
                let arImage = ARReferenceImage(image.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 0.065)
                
                arImage.name = id.name
                
                customReferenceSet.insert(arImage)
                print("gallery name: \(arImage.name!)")
                print("gallery count: \(customReferenceSet.count)")
            }
            
            
            imageFetchingGroup.leave()
            
        }
        
        
        self.configuration = ARImageTrackingConfiguration()
        imageFetchingGroup.notify(queue: .main) {
            self.configuration.trackingImages = customReferenceSet
            self.configuration.maximumNumberOfTrackedImages = 5
            self.sceneView.session.run(self.configuration)
        }
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
