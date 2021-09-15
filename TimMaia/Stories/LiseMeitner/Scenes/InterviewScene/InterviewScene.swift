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
    "Entrevistador: olá amiga, como \n você está?",
    "Lise: suave, agradeço por perguntar",
    "Entrevistador: como foi ser uma pessoa incrível?",
    "Lise: foi legal, super recomedno tentar",
    "Entrevistador: okay, vou voltar a estudar",
    "Lise: precisando de ajuda é só me chamar hehe",
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
      
      conversationNodes.append(label)
    }
  }
  
  private func animateConversation() {
    for (index, node) in conversationNodes.enumerated() {
      let aditionalTime = 3 * Double(index)
      
      let fadeIn = SKAction.fadeIn(withDuration: 1 + aditionalTime)
      let wait = SKAction.wait(forDuration: 1 + aditionalTime)
      let fadeOut = SKAction.fadeOut(withDuration: 1 + aditionalTime)
      let sequence = SKAction.sequence([fadeIn, wait, fadeOut])
      node.run(sequence)
    }
  }
  
  private func turnTvOn() {
    televisionOff.alpha = 0
    isTvOn = true
    
    animateConversation()
  }
  
  private func turnTvOff() {
    televisionOff.alpha = 1
    televisionText.alpha = 0

    isTvOn = false
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if clickableArea.contains(pos) {
      if isTvOn {
        turnTvOff()
      }
      else {
        turnTvOn()
      }
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
