//
//  LiseHelpsOttoScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 16/09/21.
//

import SpriteKit

class LiseHelpsOttoScene: SKScene {
  private lazy var ottoText: SKLabelNode = { [unowned self] in
    return childNode(withName : "OttoSpeech") as! SKLabelNode
  }()
  private lazy var liseText: SKLabelNode = { [unowned self] in
    return childNode(withName : "LiseSpeech") as! SKLabelNode
  }()
  
  static func create() -> SKScene {
    let scene = LiseHelpsOttoScene(fileNamed: "LiseHelpsOttoScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    setupText()
  }
  
  private func setupText() {
    ottoText.fontName = "NewYorkSmall-Regular"
    ottoText.text = "Hi Lise! You must have \n seen me win the Nobel \n Prize in Chemistry. \n I can't explain how we \n got to the nuclear \n fission result, can you \n help me?"
    
    liseText.fontName = "NewYorkSmall-Regular"
    liseText.text = "Hello Otto! I will send a letter to \n the committee explaining the \n research we did together. I wanted \n to know why I wasn't named \n at the awards and I wasn't \n even recognized for actually \n discovering nuclear fission."
    
    
    let fadeIn = SKAction.fadeIn(withDuration: 1)
    ottoText.run(fadeIn)
    
    let wait = SKAction.wait(forDuration: 5)
    liseText.run(SKAction.sequence([wait, fadeIn]))
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

