//
//  TrophyScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 02/09/21.
//

import SpriteKit

class TrophyScene: SKScene {
  private lazy var trophyNominee: SKSpriteNode = { [unowned self] in
    return childNode(withName : "TrophyNominee") as! SKSpriteNode
  }()
  
  static func create() -> SKScene {
    let scene = TrophyScene(fileNamed: "TrophyScene")
    
    return scene!
  }
  
  override func didMove(to view: SKView) {
    self.backgroundColor = .systemBackground
  }
  
  func touchDown(atPoint pos : CGPoint) {
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    if trophyNominee.contains(pos) {
      trophyNominee.alpha += 0.002
    }
  }
  
  func touchUp(atPoint pos : CGPoint) {
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      for t in touches { self.touchDown(atPoint: t.location(in: self)) }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
  
  
  override func update(_ currentTime: TimeInterval) {
      // Called before each frame is rendered
  }
}

