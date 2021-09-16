//
//  NuclearFissionPaperScene.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 15/09/21.
//

import SpriteKit

class NuclearFissionPaperScene: SKScene {
  private var paper: SKSpriteNode!

  private var lastTouchPosition: CGPoint!
  private var movementSize = 0
  
  private var gameEnded = false
  
  private var tooltipManager: TooltipManager!
  
  private var coreHapticsManager: NuclearFissionPaperSceneCoreHapticsManager?
  
  static func create() -> SKScene {
    let scene = NuclearFissionPaperScene(fileNamed: "NuclearFissionPaperScene")
    scene?.coreHapticsManager = DefaultNuclearFissionPaperSceneCoreHapticsManager()
    
    return scene!
  }
  
  override func didMove(to view: SKView) {
    paper = (self.childNode(withName: "//paper") as! SKSpriteNode)
    
    let paperStandByAnimation: SKAction = .repeatForever(.sequence([
      .move(by: CGVector(dx: 0, dy: -50), duration: 0.6),
      .move(by: CGVector(dx: 0, dy: 50), duration: 0.6),
      .wait(forDuration: 2)
    ]))
    
    paper.run(paperStandByAnimation)
    
    tooltipManager = TooltipManager(
      scene: self,
      startPosition: CGPoint(x: 0, y: 550),
      timeBetweenAnimations: 5,
      animationType: .slideToBottom
    )
    
    tooltipManager.startAnimation()
  }
  
  func movementDetection(pos: CGPoint) {
    if lastTouchPosition == nil {
      lastTouchPosition = pos
      return
    }
    
    if pos.y < lastTouchPosition.y {
      movementSize += 1
      lastTouchPosition = pos
    }
  }
  
  func clearTouches() {
    lastTouchPosition = nil
    movementSize = 0
  }
  
  func touchDown(atPoint pos : CGPoint) {
    tooltipManager.stopAnimation()
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    if gameEnded {
      return
    }
    
    movementDetection(pos: pos)
  }
  
  func touchUp(atPoint pos : CGPoint) {
    if gameEnded {
      return
    }
    
    if movementSize >= 5 {
      paper.removeAllActions()
      
      let paperMoveAnimation: SKAction = .sequence([
        .move(to: CGPoint(x: -7, y: -30), duration: 1.2),
        .run {
          self.coreHapticsManager?.playClickPattern()
        }
      ])
      
      paper.run(paperMoveAnimation)
      
      gameEnded = true
      
      return
    }
    
    tooltipManager.startAnimation()
    clearTouches()
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
