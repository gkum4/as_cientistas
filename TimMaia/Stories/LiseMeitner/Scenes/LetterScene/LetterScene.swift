//
//  LetterScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 07/09/21.
//

import SpriteKit

class LetterScene: SKScene {
  private var squares: [SquareProps] = []
  private var numberOfSquares = 24
  
  static func create() -> SKScene {
    let scene = LetterScene(fileNamed: "LetterScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    self.backgroundColor = .systemBackground
    
    for i in 0..<numberOfSquares {
      self.squares.append(
        SquareProps(
          checked: false,
          node: (self.childNode(withName: "//sq\(i)") as? SKSpriteNode)
        )
      )
    }
  }
  
  func touchDown(atPoint pos : CGPoint) {
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    for i in 0..<numberOfSquares {
      if self.squares[i].node?.contains(pos) == true {
        self.squares[i].node?.run(SKAction.fadeOut(withDuration: 1))
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

