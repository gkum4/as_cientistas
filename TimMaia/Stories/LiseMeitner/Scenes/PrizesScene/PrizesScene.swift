//
//  PrizesScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 14/09/21.
//

import SpriteKit

class PrizesScene: SKScene {
  private var numberOfPrizes = 4
  private var prizesNodes =  [SKSpriteNode]()
  
  private var hapticsManager: PrizesSceneHapticsManager?
  
  static func create() -> SKScene {
    let scene = PrizesScene(fileNamed: "PrizesScene")
    scene?.hapticsManager = DefaultPrizesSceneHapticsManager()

    return scene!
  }
  
  override func didMove(to view: SKView) {
    fetchPrizes()
  }
  
  private func fetchPrizes() {
    for number in 0..<numberOfPrizes {
      let backNode = childNode(withName: "PrizeBack-\(number)") as? SKSpriteNode
      prizesNodes.append(backNode!)
    }
  }
  
  private func fadeNodeOut(node: SKSpriteNode) {
    node.run(.fadeOut(withDuration: 2))
    hapticsManager?.triggerSuccess()
  }
  
  func touchDown(atPoint pos : CGPoint) {
    for index in 0..<numberOfPrizes {
      let prizeBack = prizesNodes[index]
      if prizeBack.contains(pos) {
        fadeNodeOut(node: prizeBack)
      }
    }
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

