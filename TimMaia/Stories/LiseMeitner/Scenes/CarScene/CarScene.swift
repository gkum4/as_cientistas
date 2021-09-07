//
//  CarScene.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 07/09/21.
//

import SpriteKit

class CarScene: SKScene {
  private var car: SKSpriteNode!
  private var stopPositions: [CGPoint] = []
  private var nextButton: SKSpriteNode!
  
  var numberOfStops = 4
  
  var stopStep = 0
  
  var timer: Timer!
  
  private var coreHapticsManager: CarSceneCoreHapticsManager?
  
  static func create() -> SKScene {
    let scene = CarScene(fileNamed: "CarScene")
    scene?.coreHapticsManager = DefaultCarSceneCoreHapticsManager()
    
    return scene!
  }
  
  override func didMove(to view: SKView) {
    car = self.childNode(withName: "//car") as? SKSpriteNode
    nextButton = self.childNode(withName: "//nextButton") as? SKSpriteNode
    
    for i in 1...numberOfStops {
      stopPositions.append(
        (self.childNode(withName: "//stop\(i)") as? SKSpriteNode)!.position
      )
    }
  }
  
  @objc func moveCar() {
    if stopStep == 4 {
      return
    }
    
    car.run(.move(to: stopPositions[stopStep], duration: 1))
    
    stopStep += 1
  }
  
  func touchDown(atPoint pos : CGPoint) {
//    timer = Timer.scheduledTimer(
//      timeInterval: 0.4,
//      target: self,
//      selector: #selector(self.moveCar),
//      userInfo: nil,
//      repeats: true
//    )
    
    if nextButton.contains(pos) {
      moveCar()
    }
  }
  
  func touchMoved(toPoint pos : CGPoint) {
  }
  
  func touchUp(atPoint pos : CGPoint) {
//    print("timer stop")
//    timer.invalidate()
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

