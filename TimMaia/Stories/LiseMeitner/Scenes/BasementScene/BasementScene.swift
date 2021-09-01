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
  
  private var dust1: SKSpriteNode!
  private var dust2: SKSpriteNode!
  var dustRemoveStep = 0
  
  static func create() -> SKScene {
    return PeriodicTableScene(fileNamed: "BasementScene")!
  }
  
  override func didMove(to view: SKView) {
    self.dust1 = self.childNode(withName: "//dust1") as? SKSpriteNode
    self.dust2 = self.childNode(withName: "//dust2") as? SKSpriteNode
    
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
    if dustRemoveStep >= 7 {
      timer.invalidate()
      blowDetector.stop()
      
      onGameEnd()
      return
    }
    
    if !blowDetector.detectedBlow() {
      return
    }
    
    dust1.run(.move(by: CGVector(dx: -50, dy: 50), duration: 0.5))
    dust2.run(.move(by: CGVector(dx: 50, dy: 50), duration: 0.5))
    dustRemoveStep += 1
  }
  
  func onGameEnd() {
    print("dust remove game finished")
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
