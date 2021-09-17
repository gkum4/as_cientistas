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
    ottoText.fontName = "NewYorkSmall-Regular"
    ottoText.text = "Hi Lise! You must have \nseen me win the Nobel \nPrize in Chemistry. \nI can't explain how we \ngot to the nuclear \nfission result, can you \nhelp me?"
    
    liseText.fontName = "NewYorkSmall-Regular"
    liseText.text = "Hello Otto! I will send a letter to \nthe committee explaining the \nresearch we did together. I wanted \nto know why I wasn't named \nat the awards and I wasn't \neven recognized for actually \ndiscovering nuclear fission."
    
    
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

