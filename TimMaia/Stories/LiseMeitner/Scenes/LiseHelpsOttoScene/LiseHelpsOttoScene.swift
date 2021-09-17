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
  
  static func create() -> SKScene {
    let scene = LiseHelpsOttoScene(fileNamed: "LiseHelpsOttoScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    setupText()
  }
  
  private func setupText() {
    let ottoText = SKLabelNode(text: "Hi Lise! You must have seen me win the Nobel Prize in Chemistry. I can't explain how we got to the nuclear fission result, can you help me?")
    ottoText.zPosition = 3
    ottoText.numberOfLines = 0
    ottoText.fontName = "NewYorkSmall-Regular"
    ottoText.position = ottoTextArea.position
    ottoText.preferredMaxLayoutWidth = ottoTextArea.frame.width
    addChild(ottoText)
    
    let liseText = SKLabelNode(text: "Hello Otto! I will send a letter to the committee explaining the research we did together. I wanted to know why I wasn't named at the awards and I wasn't even recognized for actually discovering nuclear fission.")
    liseText.numberOfLines = 0
    liseText.fontName = "NewYorkSmall-Regular"
    liseText.position = liseTextArea.position
    liseText.preferredMaxLayoutWidth = liseTextArea.frame.width
    addChild(liseText)
    
    
//    let fadeIn = SKAction.fadeIn(withDuration: 1)
//    ottoText.run(fadeIn)
//
//    let wait = SKAction.wait(forDuration: 5)
//    liseText.run(SKAction.sequence([wait, fadeIn]))
  }
  
  func touchDown(atPoint pos : CGPoint) {
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

