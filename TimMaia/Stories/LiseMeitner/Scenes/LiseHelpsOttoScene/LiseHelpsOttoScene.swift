//
//  LiseHelpsOttoScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 16/09/21.
//

import SpriteKit

class LiseHelpsOttoScene: SKScene {
  private lazy var ottoTextArea: SKSpriteNode = { [unowned self] in
    return childNode(withName : "OttoTextArea") as! SKSpriteNode
  }()
  private lazy var liseTextArea: SKSpriteNode = { [unowned self] in
    return childNode(withName : "LiseTextArea") as! SKSpriteNode
  }()
  
  private var nextButton: SKSpriteNode!
  
  private var canGoToNextScene = false
  
  static func create() -> SKScene {
    let scene = LiseHelpsOttoScene(fileNamed: "LiseHelpsOttoScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    nextButton = (self.childNode(withName: "button") as! SKSpriteNode)
    nextButton.alpha = 0
    
    setupText()
  }
  
  private func setupText() {
    let ottoText = SKLabelNode()
    ottoText.fontName = "NewYorkSmall-Regular"
    ottoText.text = NSLocalizedString("LiseHelpsOttoScene1", comment: "Comment")
    ottoText.position = ottoTextArea.position
    ottoText.numberOfLines = 0
    ottoText.alpha = 0
    ottoText.preferredMaxLayoutWidth = ottoTextArea.frame.width
    addChild(ottoText)
    
    
    let liseText = SKLabelNode()
    liseText.fontName = "NewYorkSmall-Regular"
    liseText.text = NSLocalizedString("LiseHelpsOttoScene2", comment: "Comment")
    liseText.position = liseTextArea.position
    liseText.numberOfLines = 0
    liseText.alpha = 0
    liseText.preferredMaxLayoutWidth = liseTextArea.frame.width
    addChild(liseText)
    
    
    let fadeIn = SKAction.fadeIn(withDuration: 1)
    ottoText.run(fadeIn)
    
    let wait = SKAction.wait(forDuration: 5)
    liseText.run(SKAction.sequence([
      wait,
      fadeIn,
      .wait(forDuration: 2),
      .run {
        self.nextButton.run(.fadeIn(withDuration: 1.5))
        self.canGoToNextScene = true
      }
    ]))
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if canGoToNextScene && nextButton.contains(pos) {
      SceneTransition.executeDefaultTransition(
        from: self,
        to: NobelLetterScene.create(),
        nextSceneScaleMode: .aspectFill,
        transition: SKTransition.push(with: .left, duration: 2)
      )
    }
  }
  
  func touchMoved(toPoint pos : CGPoint) {
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

