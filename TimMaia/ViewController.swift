//
//  ViewController.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 24/08/21.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func loadView() {
    if let scene = SKScene(fileNamed: "PeriodicTableScene") {
      let sceneView = SKView()
      scene.scaleMode = .aspectFit
      sceneView.presentScene(scene)

      self.view = sceneView
    }
  }
}

