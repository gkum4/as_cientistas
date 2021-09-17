//
//  LiseTeachingScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 13/09/21.
//

import SpriteKit

class LiseTeachingScene: SKScene {
  private lazy var firstScene: SKSpriteNode = { [unowned self] in
    return childNode(withName : "TeachingScene-0") as! SKSpriteNode
  }()
  private lazy var secondScene: SKSpriteNode = { [unowned self] in
    return childNode(withName : "TeachingScene-1") as! SKSpriteNode
  }()
  
  private var hapticsManager: LiseTeachingSceneHapticsManager?
  
  static func create() -> SKScene {
    let scene = LiseTeachingScene(fileNamed: "LiseTeachingScene")
    scene?.hapticsManager = DefaultLiseTeachingSceneHapticsManager()

    return scene!
  }
  
  override func didMove(to view: SKView) {
  }
  
  func touchDown(atPoint pos : CGPoint) {
  }
  
  func touchMoved(toPoint pos : CGPoint) {
  }
  
  func touchUp(atPoint pos : CGPoint) {
    changeScene()
  }
  
  private func changeScene() {
    hapticsManager?.triggerSuccess()
    firstScene.run(.fadeOut(withDuration: 2))
    secondScene.run(.fadeIn(withDuration: 2))
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

