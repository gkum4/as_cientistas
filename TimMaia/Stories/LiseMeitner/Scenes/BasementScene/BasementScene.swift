//
//  BasementScene.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 31/08/21.
//

import SpriteKit

class BasementScene: SKScene {
  var blowDetector = BlowDetector(detectionThreshold: -9)
  var timer: Timer!
  
  private var dusts: [SKSpriteNode] = []
  
  private var numberOfDusts = 3
  
  private var dustToRemove = 0
  
  private var animationRunning = false
  
  private var coreHapticsManager: BasementSceneCoreHapticsManager?
  
  static func create() -> SKScene {
    let scene = BasementScene(fileNamed: "BasementScene")
    scene?.coreHapticsManager = DefaultBasementSceneCoreHapticsManager()
    
    return scene!
  }
  
  override func didMove(to view: SKView) {
    for i in 1...numberOfDusts {
      dusts.append((self.childNode(withName: "dust\(i)") as! SKSpriteNode))
    }
    
    blowDetector.startDetecting()
    
    timer = Timer.scheduledTimer(
      timeInterval: 0.2,
      target: self,
      selector: #selector(self.moveDust),
      userInfo: nil,
      repeats: true
    )
  }
  
  @objc func moveDust() {
    if !blowDetector.detectedBlow() || animationRunning {
      return
    }
    
    animationRunning = true
    
    blowDetector.stop()
    self.coreHapticsManager?.playSpreadPattern()
    blowDetector.startDetecting()
    
    let dustRemoveAnimation: SKAction = .sequence([
      .group([
        .scale(by: 1.1, duration: 1),
        .fadeOut(withDuration: 1)
      ]),
      .run {
        self.animationRunning = false
      }
    ])
    
    dusts[dustToRemove].run(dustRemoveAnimation)
    
    dustToRemove += 1
    
    if dustToRemove == numberOfDusts {
      onGameEnd()
    }
  }
  
  func onGameEnd() {
    timer.invalidate()
    blowDetector.stop()
    
    print("game ended")
  }
  
  func touchDown(atPoint pos : CGPoint) {
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
