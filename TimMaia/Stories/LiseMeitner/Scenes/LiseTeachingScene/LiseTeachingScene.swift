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
  
  private var tooltipManager: TooltipManager!
  private var hapticsManager: LiseTeachingSceneHapticsManager?
  
  private var sceneChanged = false
  
  static func create() -> SKScene {
    let scene = LiseTeachingScene(fileNamed: "LiseTeachingScene")
    scene?.hapticsManager = DefaultLiseTeachingSceneHapticsManager()

    return scene!
  }
  
  override func didMove(to view: SKView) {
    tooltipManager = TooltipManager(
      scene: self,
      startPosition: CGPoint(x: 0, y: 0),
      timeBetweenAnimations: 5,
      animationType: .touch
    )
    tooltipManager.startAnimation()
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if sceneChanged {
      tooltipManager.stopAnimation()
      
      SceneTransition.executeDefaultTransition(
        from: self,
        to: PeriodicTableScene.create(),
        nextSceneScaleMode: .aspectFill,
        transition: SKTransition.push(with: .down, duration: 2)
      )
      return
    }
    
    changeScene()
  }
  
  func touchMoved(toPoint pos : CGPoint) {
  }
  
  func touchUp(atPoint pos : CGPoint) {
  }
  
  private func changeScene() {
    tooltipManager.stopAnimation()
    hapticsManager?.triggerSuccess()
    firstScene.run(.fadeOut(withDuration: 2))
    secondScene.run(.sequence([
      .fadeIn(withDuration: 2),
      .run {
        self.sceneChanged = true
        self.tooltipManager.startAnimation()
      }
    ]))
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

