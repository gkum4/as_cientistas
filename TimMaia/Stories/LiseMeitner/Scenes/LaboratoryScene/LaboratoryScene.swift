//
//  LaboratoryScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 12/09/21.
//

import SpriteKit

class LaboratoryScene: SKScene {
  private lazy var notice: SKLabelNode = { [unowned self] in
    return childNode(withName : "LaboratoryNotice") as! SKLabelNode
  }()
  private lazy var knobArea: SKSpriteNode = { [unowned self] in
    return childNode(withName : "KnobArea") as! SKSpriteNode
  }()
  private lazy var doorKnob: SKSpriteNode = { [unowned self] in
    return childNode(withName : "DoorKnob") as! SKSpriteNode
  }()
  
  
  private var hapticsManager: LaboratorySceneHapticsManager?
  private var totalClicks = 0
  
  
  static func create() -> SKScene {
    let scene = LaboratoryScene(fileNamed: "LaboratoryScene")
    scene?.hapticsManager = DefaultLaboratorySceneHapticsManager()

    return scene!
  }
  
  override func didMove(to view: SKView) {
    notice.text = "Men \n only"
  }
  
  func touchDown(atPoint pos : CGPoint) {
  }
  
  func touchMoved(toPoint pos : CGPoint) {
  }
  
  func touchUp(atPoint pos : CGPoint) {
    if knobArea.contains(pos) {
      animateKnob()
    }
  }
  
  private func animateKnob() {
    totalClicks += 1
    
    let knobDown = SKAction.rotate(toAngle: 0.1, duration: 0.2)
    let knobUp = SKAction.rotate(toAngle: 0, duration: 0.2)
    let seq = SKAction.sequence([knobDown, knobUp])
    doorKnob.run(seq)
    hapticsManager?.triggerWarning()
    if totalClicks > 3 {
      notice.run(.fadeAlpha(to: 1, duration: 1))
    }
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

