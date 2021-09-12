//
//  DadScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 12/09/21.
//

import SpriteKit

class DadScene: SKScene {
  private lazy var badge: SKLabelNode = { [unowned self] in
    return childNode(withName : "DadBadge") as! SKLabelNode
  }()
  private var dadSpeech = DynamicTextManager(text: "Do not worry, I will pay for your studies",
                                    startPos: CGPoint(x: -220, y: -350),
                                    textWidth: 450, lineHeight: 100, textRotation: 0.2)
  
  private var textSize: Int?
  private var letterNodes = [SKLabelNode]()
  
  static func create() -> SKScene {
    let scene = DadScene(fileNamed: "DadScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    badge.text = "Dad"
    
    textSize = dadSpeech.textSize
    letterNodes = dadSpeech.lettersNodes
    for node in letterNodes {
      addChild(node)
    }
  }
  
  func touchDown(atPoint pos : CGPoint) {
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    for i in 1..<textSize!-1 {
      if letterNodes[i].contains(pos) {
        letterNodes[i - 1].run(SKAction.fadeIn(withDuration: 1))
        letterNodes[i].run(SKAction.fadeIn(withDuration: 1))
        letterNodes[i + 1].run(SKAction.fadeIn(withDuration: 1))
      }
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
