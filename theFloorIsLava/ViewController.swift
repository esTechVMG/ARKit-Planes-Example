//
//  ViewController.swift
//  theFloorIsLava
//
//  Created by A4-iMAC01 on 24/02/2021.
//

import UIKit
import ARKit
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [
            .showWorldOrigin,
            .showFeaturePoints
        ]
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        
    }
    func createLava(planeAnchor:ARPlaneAnchor) -> SCNNode {
        let lavaNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
        lavaNode.position = SCNVector3(planeAnchor.center.x,planeAnchor.center.y,planeAnchor.center.z)
        lavaNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "lava")
        lavaNode.position = SCNVector3(0,0,-1)
        lavaNode.eulerAngles = SCNVector3(90.degreesToRadians,0,0)
        lavaNode.geometry?.firstMaterial?.isDoubleSided = true
        return lavaNode
    }
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
        let lavaNode = createLava(planeAnchor: anchor as! ARPlaneAnchor)
        node.addChildNode(lavaNode)
        print("Nueva superficie horizontal detectada, nuevo ARPlaneAnchor añadido")
    }
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
        print("Se ha actualizado el ancho del suelo")
        node.enumerateChildNodes {(childNode,_) in
            childNode.removeFromParentNode()
            let lavaNode = createLava(planeAnchor: anchor as! ARPlaneAnchor)
            node.addChildNode(lavaNode)
        }
    }
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
        print("Actualizando las anchas del suelo")
        node.enumerateChildNodes {(childNode,_) in
            childNode.removeFromParentNode()
        }
    }
}
extension Int{
    var degreesToRadians:Double{return Double(self) * .pi/180}
}
