//
//  ViewController.swift
//  ARoundUs
//
//  Created by niab on Mar/21/21.
//
//test commit
import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "00image", bundle: Bundle.main) {
            configuration.trackingImages = trackedImages
            configuration.maximumNumberOfTrackedImages = 5
            
            //print("Images found")
            
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
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
            
            switch imageAnchor.referenceImage.name {

            case "square-Goryokaku":
                let spriteKitScene = SKScene(fileNamed: "Goryokaku")
                addARnode(imageAnchor, spriteKitScene, node)

            case "square-Lake-Toya":
                let spriteKitScene = SKScene(fileNamed: "Lake-Toya")
                addARnode(imageAnchor, spriteKitScene, node)
                
            case "square-Sapporo-Odori-Park":
                let spriteKitScene = SKScene(fileNamed: "Sapporo-Odori-Park")
                addARnode(imageAnchor, spriteKitScene, node)
                
            case "square-Shiretoko-National-Park":
                let spriteKitScene = SKScene(fileNamed: "Shiretoko-National-Park")
                addARnode(imageAnchor, spriteKitScene, node)
                
            case "square-Shirogane-Blue-Pond":
                let spriteKitScene = SKScene(fileNamed: "Shirogane-Blue-Pond")
                addARnode(imageAnchor, spriteKitScene, node)

            default:
                break
            }
        }
        
        return node
    }
    
}
