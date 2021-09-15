//
//  OttoLetterScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 15/09/21.
//

import SpriteKit

class NobelLetterScene: SKScene {
  private var text = DynamicTextManager(text: "Vou ter que te ensinar a fazer tudo? Da seus corre parceiro",
                                    startPos: CGPoint(x: -220, y: 470),
                                    textWidth: 440, lineHeight: 120, textRotation: 0.1)

  
  private var textSize: Int?
  private var letterNodes = [SKLabelNode]()
  
  static func create() -> SKScene {
    let scene = NobelLetterScene(fileNamed: "NobelLetterScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    self.backgroundColor = .systemBackground

    textSize = text.textSize
    letterNodes = text.lettersNodes
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

