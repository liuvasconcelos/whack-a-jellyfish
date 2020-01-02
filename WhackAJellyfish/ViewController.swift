//
//  ViewController.swift
//  WhackAJellyfish
//
//  Created by Livia Vasconcelos on 02/01/20.
//  Copyright © 2020 Livia Vasconcelos. All rights reserved.
//

import UIKit
import ARKit
import Each

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timer: UILabel!
    
    var timerControl = Each(1).seconds
    var countDown    = 10
    
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
        } else if countDown > 0 {
            let results = hitTest?.first
            let node    = results?.node ?? SCNNode()
            
            if node.animationKeys.isEmpty {
                SCNTransaction.begin()
                self.animateNode(node: node)
                SCNTransaction.completionBlock = {
                    node.removeFromParentNode()
                    self.addNode()
                    self.restoreTimer()
                }
                SCNTransaction.commit()
            }
            
        }
    }

    @IBAction func play(_ sender: Any) {
        self.setTimer()
        self.addNode()
        self.playButton.isEnabled = false
    }
    
    @IBAction func reset(_ sender: Any) {
        timerControl.stop()
        self.restoreTimer()
        self.playButton.isEnabled = true
        
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
    }
    
    func addNode() {
        let jellyfishScene = SCNScene(named: "art.scnassets/Jellyfish.scn")
        let jellyfishNode  = jellyfishScene?.rootNode.childNode(withName: "Sphere", recursively: false)
        
        jellyfishNode?.position = SCNVector3(randomNumbers(firstNum: -1, secondNum: 1),
                                             randomNumbers(firstNum: -0.5, secondNum: 0.5),
                                             randomNumbers(firstNum: -1, secondNum: 1))
        if let node = jellyfishNode {
            self.sceneView.scene.rootNode.addChildNode(node)
        }
        
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
    
    func randomNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    func setTimer() {
        timerControl.perform { () -> NextStep in
            self.countDown -= 1
            self.timer.text = String(self.countDown)
            
            if self.countDown == 0 {
                self.timer.text = "You lose!"
                return .stop
            }
            return .continue
        }
    }
    
    func restoreTimer() {
        self.countDown = 10
        self.timer.text = String(self.countDown)
    }
}

