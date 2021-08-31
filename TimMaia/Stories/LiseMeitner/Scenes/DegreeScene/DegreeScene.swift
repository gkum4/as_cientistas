//
//  DegreeScene.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 25/08/21.
//

import SpriteKit

class DegreeScene: SKScene {
  private var squares: [SquareProps] = []
  private var lines: [SKShapeNode] = []
  private var squareCheck: SKSpriteNode!
  private var startedTouching = false
  
  private var numberOfSquares = 74
  
  override func didMove(to view: SKView) {
    for i in 0..<numberOfSquares {
      self.squares.append(
        SquareProps(
          checked: false,
          node: (self.childNode(withName: "//sq\(i)") as? SKSpriteNode)
        )
      )
      self.squares[i].node?.alpha = 0;
    }
    
    var auxPos: CGPoint
    
    for i in 0...numberOfSquares-2 {
      auxPos = self.squares[i+1].node!.position
      
      let line = getLine(self.squares[i].node!.position, auxPos)
      
      self.lines.append(line)
      
      self.addChild(line)
    }
    
    self.squareCheck = self.childNode(withName: "//sqCheck") as? SKSpriteNode
    self.squareCheck.color = .green
    self.squareCheck.alpha = 0
  }
  
  private func getLine(_ pos1: CGPoint, _ pos2: CGPoint) -> SKShapeNode {
    let path = CGMutablePath()
    path.move(to: pos1)
    path.addLine(to: pos2)
    
    let line = SKShapeNode()
    line.path = path
    line.fillColor = .clear
    line.lineWidth = 40
    line.strokeColor = .red
    line.lineCap = .round
    line.glowWidth = 15
    
    return line
  }
  
  private func clearTouches() {
    startedTouching = false
    
    for i in 0..<numberOfSquares {
      self.squares[i].checked = false
      self.squares[i].node?.alpha = 0
      
      if i < numberOfSquares-1 {
        self.lines[i].alpha = 1
      }
    }
    
    self.squareCheck.alpha = 0
  }
  
  private func checkIfCompletedGame() -> Bool {
    for i in 0..<numberOfSquares {
      if !self.squares[i].checked {
        return false
      }
    }
    
    return true
  }
  
  func touchDown(atPoint pos : CGPoint) {
    for i in 0..<numberOfSquares {
      if self.squares[i].node?.contains(pos) == true {
        return
      }
    }
    
    clearTouches()
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    if self.squares[0].node?.contains(pos) == true {
      startedTouching = true
    }
    
    if !startedTouching {
      return
    }
    
    for i in 0..<numberOfSquares {
      if self.squares[i].node?.contains(pos) == true {
        self.squares[i].checked = true
        
        if i < numberOfSquares-1 {
          self.lines[i].alpha = 0
        }
      }
    }
  }
  
  func touchUp(atPoint pos : CGPoint) {
    for i in 0..<numberOfSquares {
      if !self.squares[i].checked {
        clearTouches()
        return
      }
    }
    
    self.squareCheck.alpha = 1
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
