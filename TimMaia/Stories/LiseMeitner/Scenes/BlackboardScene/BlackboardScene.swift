//
//  BlackboardScene.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 02/09/21.
//

import SpriteKit

class BlackboardScene: SKScene {
  private var boardTexts: [SKLabelNode?] = []
  let numberOfBoardTexts = 3
  var eraseTextStep = 0
  var textToErase = 0
  
  var didGameEnded = false
  
  private var coreHapticsManager: BlackboardSceneCoreHapticsManager?
  
  static func create() -> SKScene {
    let scene = BlackboardScene(fileNamed: "BlackboardScene")
    scene?.coreHapticsManager = DefaultBlackboardSceneCoreHapticsManager()
    
    return scene!
  }
  
  override func didMove(to view: SKView) {
    for i in 1...numberOfBoardTexts {
      boardTexts.append((self.childNode(withName: "//text\(i)") as? SKLabelNode))
    }
  }
  
  var textEraseAnimation: SKAction = .group([
    .scale(by: 1.1, duration: 0.9),
    .sequence([
      .rotate(byAngle: 0.0872665, duration: 0.1),
      .rotate(byAngle: CGFloat(-0.0872665*2), duration: 0.1),
      .rotate(byAngle: CGFloat(0.0872665), duration: 0.1)
    ]),
    .fadeOut(withDuration: 1.2)
  ])
  
  @objc override func shake() {
    if didGameEnded {
      return
    }
    
    coreHapticsManager?.playRumblePattern()
    
    boardTexts[textToErase]?.run(textEraseAnimation)
    textToErase += 1
    
    if textToErase >= numberOfBoardTexts {
      onGameEnd()
      return
    }
  }
  
  func onGameEnd() {
    didGameEnded = true
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
