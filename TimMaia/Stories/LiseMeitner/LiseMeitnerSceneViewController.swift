//
//  ViewController.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 24/08/21.
//

import UIKit
import SpriteKit

class LiseMeitnerSceneViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func loadView() {
    let scene = MapZoomScene.create()
    let sceneView = SKView()
    scene.scaleMode = .aspectFill
    sceneView.presentScene(scene)

    self.view = sceneView
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .allButUpsideDown
    } else {
      return .all
    }
  }
}

extension LiseMeitnerSceneViewController: LiseFinalSceneDelegate {
  func didFinishScene() {
    self.dismiss(animated: true, completion: nil)
  }
}
