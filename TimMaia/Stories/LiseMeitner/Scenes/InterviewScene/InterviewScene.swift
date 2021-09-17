//
//  InterviewScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 15/09/21.
//

import SpriteKit

class InterviewScene: SKScene {
  private lazy var televisionOff: SKSpriteNode = { [unowned self] in
    return childNode(withName : "TelevisionOff") as! SKSpriteNode
  }()
  private lazy var televisionOn: SKSpriteNode = { [unowned self] in
    return childNode(withName : "TelevisionOn") as! SKSpriteNode
  }()
  private lazy var clickableArea: SKSpriteNode = { [unowned self] in
    return childNode(withName : "TelevisionButtonArea") as! SKSpriteNode
  }()
  private lazy var televisionText: SKLabelNode = { [unowned self] in
    return childNode(withName : "TelevisionText") as! SKLabelNode
  }()
  
  
  private var isTvOn: Bool = false
  
  private var conversationNodes = [SKLabelNode]()
  private var conversation: [String] = [
    "👱🏻‍♂️ Hi Lise, welcome!",
    "👩🏻‍🦰 Thanks! It's great to be here.",
    "👱🏻‍♂️ Tell us about dinner with \nPresident Truman and how it \nfelt to be recognized as Woman \nof the Year.",
    "👩🏻‍🦰 It was a great dinner, I was \nvery happy for the nomination.",
    "👱🏻‍♂️ Great! This shows that your \nwork is very important to the world, \neven without Otto having recognized \nyou in the Nobel Prize.",
    "👩🏻‍🦰 Yes! He should have named me at \nthe awards, since I was the one \nwho discovered nuclear fission. \nBut anyway I'm being recognized \nin other ways.",
  ]
  
  static func create() -> SKScene {
    let scene = InterviewScene(fileNamed: "InterviewScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    setupConversation()
  }
  
  private func setupConversation() {
    for line in conversation {
      
      let label = SKLabelNode(text: line)
      label.position = televisionText.position
      label.alpha = 0
      label.numberOfLines = 0
      label.fontColor = .black
      label.fontName = "NewYorkSmall-Regular"
      label.fontSize = 40
      
      conversationNodes.append(label)
      addChild(label)
    }
  }
  
  private func animateConversation() {
    for (index, node) in conversationNodes.enumerated() {
      let aditionalTime = 6 * Double(index)
      
      let beginAfter = SKAction.wait(forDuration: aditionalTime)
      let fadeIn = SKAction.fadeIn(withDuration: 1)
      let wait = SKAction.wait(forDuration: 4)
      let fadeOut = SKAction.fadeOut(withDuration: 1)
      let sequence = SKAction.sequence([beginAfter, fadeIn, wait, fadeOut])
      node.run(sequence)
    }
  }
  
  private func turnTvOn() {
    televisionOff.alpha = 0
    isTvOn = true

    animateConversation()
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if clickableArea.contains(pos) {
      turnTvOn()
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
