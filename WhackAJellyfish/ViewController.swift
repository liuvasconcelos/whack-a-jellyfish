//
//  ViewController.swift
//  WhackAJellyfish
//
//  Created by Livia Vasconcelos on 02/01/20.
//  Copyright © 2020 Livia Vasconcelos. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin,
                                       ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as? SCNView
        let touchCoordinates  = sender.location(in: sceneViewTappedOn)
        let hitTest           = sceneViewTappedOn?.hitTest(touchCoordinates)
        
        if hitTest?.isEmpty ?? true {
            print("Did not touch")
        } else {
            let results = hitTest?.first
            let node    = results?.node ?? SCNNode()
            
            if node.animationKeys.isEmpty {
                self.animateNode(node: node)
            }
            
        }
    }

    @IBAction func play(_ sender: Any) {
        addNode()
        self.playButton.isEnabled = false
    }
    
    @IBAction func reset(_ sender: Any) {
    }
    
    func addNode() {
        let jellyfishScene = SCNScene(named: "art.scnassets/Jellyfish.scn")
        let jellyfishNode  = jellyfishScene?.rootNode.childNode(withName: "Sphere", recursively: false)
        
        jellyfishNode?.position = SCNVector3(0,0,-1)
        self.sceneView.scene.rootNode.addChildNode(jellyfishNode ?? SCNNode())
    }
    
    func animateNode(node: SCNNode) {
        let spin          = CABasicAnimation(keyPath: "position")
        spin.fromValue    = node.presentation.position
        spin.toValue      = SCNVector3(node.presentation.position.x - 0.2,
                                       node.presentation.position.y - 0.2,
                                       node.presentation.position.z - 0.2)
        spin.duration     = 0.07
        spin.autoreverses = true
        spin.repeatCount  = 5
        node.addAnimation(spin, forKey: "position")
    }
}

