//
//  LiseWithBoysScene.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 13/09/21.
//

import SpriteKit

class LiseWithBoysScene: SKScene {
  private var blackboard: SKEffectNode!
  private var boys: [SKSpriteNode] = []
  private var lise: SKSpriteNode!
  private var dragging: SKSpriteNode!
  
  private var tooltipManager1: TooltipManager!
  private var tooltipManager2: TooltipManager!
  
  var numberOfBoys = 5
  var gameEnded = false
  
  private var coreHapticsManager: LiseWithBoysSceneCoreHapticsManager?
  
  static func create() -> SKScene {
    let scene = LiseWithBoysScene(fileNamed: "LiseWithBoysScene")
    scene?.coreHapticsManager = DefaultLiseWithBoysSceneCoreHapticsManager()
    
    return scene!
  }
  
  override func didMove(to view: SKView) {
    let blackboardImage = (self.childNode(withName: "blackboard") as! SKSpriteNode)
    blackboardImage.removeFromParent()
    
    blackboard = SKEffectNode()
    blackboard.addChild(blackboardImage)
    
    let blur = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": 25])
    blackboard.filter = blur
    blackboard.zPosition = -1
    
    self.addChild(blackboard)
    
    for i in 1...numberOfBoys {
      boys.append((self.childNode(withName: "boy\(i)") as! SKSpriteNode))
    }
    
    lise = (self.childNode(withName: "lise") as! SKSpriteNode)
    
    tooltipManager1 = TooltipManager(
      scene: self,
      startPosition: boys[numberOfBoys-1].position,
      timeBetweenAnimations: 7,
      animationType: .slideToLeft
    )
    tooltipManager2 = TooltipManager(
      scene: self,
      startPosition: boys[numberOfBoys-2].position,
      timeBetweenAnimations: 7,
      animationType: .slideToRight
    )
    
    tooltipManager1.startAnimation()
    tooltipManager2.startAnimation()
  }
  
  private func onGetBoy(boy: SKSpriteNode) {
    coreHapticsManager?.playGrabPattern()
    
    dragging = boy
    dragging.run(.group([
      .scale(by: 1.1, duration: 0.3),
      .move(by: CGVector(dx: 0, dy: 10), duration: 0.3)
    ]))
  }
  
  private func onDismissBoy() {
    coreHapticsManager?.playGrabPattern()
    
    dragging.run(.group([
      .scale(by: 0.9, duration: 0.3),
      .move(by: CGVector(dx: 0, dy: -10), duration: 0.3)
    ]))
    dragging = nil
    
    checkBoysAtSide()
  }
  
  private func checkBoysAtSide() {
    var numberOfBoysAtSide = 0
    
    for boy in boys.reversed() {
      if boy.position.x > 300 || boy.position.x < -300 {
        numberOfBoysAtSide += 1
      }
    }
    
    unblurBlackboard(numberOfBoysAtSide: numberOfBoysAtSide)
    
    if numberOfBoysAtSide == numberOfBoys {
      onGameEnd()
    }
  }
  
  private func unblurBlackboard(numberOfBoysAtSide: Int) {
    let blur = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": 25-(5*numberOfBoysAtSide)])
    blackboard.filter = blur
  }
  
  func onGameEnd() {
    gameEnded = true
    
    tooltipManager1.stopAnimation()
    tooltipManager2.stopAnimation()
    
    for boy in boys {
      if boy.position.x > 0 {
        boy.run(.move(by: CGVector(dx: 280, dy: 0), duration: 1))
      } else {
        boy.run(.move(by: CGVector(dx: -280, dy: 0), duration: 1))
      }
    }
    
    let blackboardAnimation: SKAction = .sequence([
      .wait(forDuration: 1),
      .scale(by: 1.1, duration: 1)
    ])
    
    let liseAnimation: SKAction = .sequence([
      .wait(forDuration: 1),
      .move(by: CGVector(dx: 0, dy: 200), duration: 1)
    ])
    
    blackboard.run(blackboardAnimation)
    lise.run(liseAnimation)
    
    print("game ended")
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if gameEnded {
      return
    }
    
    for boy in boys.reversed() {
      if boy.contains(pos) {
        tooltipManager1.stopAnimation()
        tooltipManager2.stopAnimation()
        onGetBoy(boy: boy)
        return
      }
    }
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    if gameEnded {
      return
    }
    
    if dragging != nil {
      dragging.position.x = pos.x
    }
  }
  
  func touchUp(atPoint pos : CGPoint) {
    if gameEnded {
      return
    }
    
    if dragging != nil {
      tooltipManager1.startAnimation()
      tooltipManager2.startAnimation()
      onDismissBoy()
    }
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
