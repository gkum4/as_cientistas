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
  
  private var nextButton: SKSpriteNode!
  
  private var tooltipManager: TooltipManager!
  private var coreHapticsManager: NuclearFissionPaperSceneCoreHapticsManager?
  private var symbolsManager: SymbolsManager!
  
  static func create() -> SKScene {
    let scene = NuclearFissionPaperScene(fileNamed: "NuclearFissionPaperScene")
    scene?.coreHapticsManager = DefaultNuclearFissionPaperSceneCoreHapticsManager()
    
    return scene!
  }
  
  override func didMove(to view: SKView) {
    paper = (self.childNode(withName: "//paper") as! SKSpriteNode)
    nextButton = (self.childNode(withName: "button") as! SKSpriteNode)
    nextButton.alpha = 0
    
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
    
    symbolsManager = SymbolsManager(scene: self)
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
    if gameEnded {
      if nextButton.contains(pos) {
        SceneTransition.executeDefaultTransition(
          from: self,
          to: InstituteAttackedScene.create(),
          nextSceneScaleMode: .aspectFill,
          transition: SKTransition.push(with: .down, duration: 2)
        )
      }
      
      return
    }
    
    tooltipManager.stopAnimation()
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    symbolsManager.generateAnimatedSymbol(at: pos)
    
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
      
      let paperMoveAnimation: SKAction = .move(
        to: CGPoint(x: -7, y: -30),
        duration: 1.2
      )
      
      paper.run(paperMoveAnimation)
      
      self.run(.sequence([
        .wait(forDuration: 1.21),
        .run {
          self.coreHapticsManager?.playClickPattern()
          self.nextButton.run(.sequence([
            .fadeIn(withDuration: 1.5),
            .run {
              self.gameEnded = true
            }
          ]))
        }
      ]))
      
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
