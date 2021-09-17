//
//  TrophyScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 02/09/21.
//

import SpriteKit

class TrophyScene: SKScene {
  private lazy var trophy: SKSpriteNode = { [unowned self] in
    return childNode(withName : "//Trophy-1") as! SKSpriteNode
  }()
  
  private lazy var trophyNominee: SKSpriteNode = { [unowned self] in
    return childNode(withName : "//TrophyNominee") as! SKSpriteNode
  }()
  
  private var gameEnded = false
  
  private var symbolsManager: SymbolsManager!
  private var tooltipManager: TooltipManager!
  
  static func create() -> SKScene {
    let scene = TrophyScene(fileNamed: "TrophyScene")
    
    return scene!
  }
  
  override func didMove(to view: SKView) {
    self.backgroundColor = .systemBackground
    
    symbolsManager = SymbolsManager(scene: self)
    
    tooltipManager = TooltipManager(
      scene: self,
      startPosition: CGPoint(x: -70, y: -10),
      timeBetweenAnimations: 5,
      animationType: .custom
    )
    
    tooltipManager.buildCustomAction(
      positions: [
        CGPoint(x: 130, y: 190),
        CGPoint(x: -70, y: -10),
        CGPoint(x: 130, y: 190)
      ],
      timeBetweenPositions: 0.8
    )
    
    tooltipManager.startAnimation()
  }
  
  private func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
      return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
  }

  private func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
      return sqrt(CGPointDistanceSquared(from: from, to: to))
  }
  
  private func onGameEnd() {
    gameEnded = true
    
    var animationSequence: [SKAction] = []
    
    let centerPos = CGPoint(x: 5, y: 115)
    let maxDistance: CGFloat = 106
    
    for _ in 0...10 {
      var randPosition = CGPoint(x: CGFloat.random(in: -101...111), y: CGFloat.random(in: 9...221))
      
      while CGPointDistance(from: centerPos, to: randPosition) > maxDistance {
        randPosition = CGPoint(x: CGFloat.random(in: -101...111), y: CGFloat.random(in: 9...221))
      }
      
      animationSequence.append(.sequence([
        .run {
          self.symbolsManager.generateAnimatedSymbol(at: randPosition)
        },
        .wait(forDuration: 0.2)
      ]))
    }
    
    self.run(.sequence(animationSequence))
  }
  
  func touchDown(atPoint pos : CGPoint) {
    print(pos)
    tooltipManager.stopAnimation()
    
    if gameEnded {
      SceneTransition.executeDefaultTransition(
        from: self,
        to: InterviewScene.create(),
        nextSceneScaleMode: .aspectFill,
        transition: SKTransition.push(with: .left, duration: 2)
      )
    }
  }
  
  func touchMoved(toPoint pos : CGPoint) {
//    symbolsManager.generateAnimatedSymbol(at: pos)
    
    if trophyNominee.contains(pos) {
      trophyNominee.alpha += 0.008
      
      if trophyNominee.alpha >= 0.8 {
        onGameEnd()
      }
    }
  }
  
  func touchUp(atPoint pos : CGPoint) {
    if gameEnded {
      return
    }
    
    tooltipManager.startAnimation()
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

