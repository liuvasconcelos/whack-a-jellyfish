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
            let results  = hitTest?.first
            let geometry = results?.node.geometry
            
            print(geometry)
        }
    }

    @IBAction func play(_ sender: Any) {
        addNode()
    }
    
    @IBAction func reset(_ sender: Any) {
    }
    
    func addNode() {
        let jellyfishScene = SCNScene(named: "art.scnassets/Jellyfish.scn")
        let jellyfishNode  = jellyfishScene?.rootNode.childNode(withName: "Sphere", recursively: false)
        
        jellyfishNode?.position = SCNVector3(0,0,-1)
        self.sceneView.scene.rootNode.addChildNode(jellyfishNode ?? SCNNode())
    }
}

