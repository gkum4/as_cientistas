//
//  CarScene.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 07/09/21.
//

import SpriteKit

class CarScene: SKScene {
  private var car: SKSpriteNode!
  private var fishes: [SKSpriteNode] = []
  private var clickablePoints: [SKSpriteNode] = []
  private var pointPositions: [CGPoint] = []
  
  var clickablePointIds = [1, 5, 10, 13]
  
  var actualPointId = 0
  
  var numberOfPoints = 18
  var numberOfFishes = 3
  
  var animationRunning = false
  
  var discoverablePoints = 1
  
  private var coreHapticsManager: CarSceneCoreHapticsManager?
  
  static func create() -> SKScene {
    let scene = CarScene(fileNamed: "CarScene")
    scene?.coreHapticsManager = DefaultCarSceneCoreHapticsManager()
    
    return scene!
  }
  
  override func didMove(to view: SKView) {
    self.backgroundColor = UIColor(red: 0.241, green: 0.185, blue: 0.154, alpha: 1)
    
    car = (self.childNode(withName: "car") as! SKSpriteNode)
    
    for i in 0..<numberOfPoints {
      let positionNode = (self.childNode(withName: "point\(i)Position") as! SKSpriteNode)
      positionNode.alpha = 0
      
      pointPositions.append(
        positionNode.position
      )
      
      if i < clickablePointIds.count {
        clickablePoints.append(
          (self.childNode(withName: "point\(i)") as! SKSpriteNode)
        )
        clickablePoints[i].alpha = 0.5
      }
    }
    
    for i in 0..<numberOfFishes {
      fishes.append((self.childNode(withName: "fish\(i)") as! SKSpriteNode))
      fishes[i].run(.repeatForever(.sequence([
        .rotate(byAngle: CGFloat(0.0872665*2), duration: 0.2),
        .rotate(byAngle: CGFloat(-0.0872665*2), duration: 0.2),
      ])))
    }
  }
  
//  private func getMoveCarAnimation(
//    from startPoint: CGPoint,
//    to endPoint: CGPoint,
//    rotationType: CarSceneCarRotationType
//  ) -> SKAction {
//    let adjacentLeg = abs(startPoint.x - endPoint.x)
//    let oppositeLeg = abs(startPoint.y - endPoint.y)
//    var angleToRotate = atan(oppositeLeg / adjacentLeg)
//    
//    if rotationType == .anticlockwise {
//      angleToRotate *= -1
//    }
//    
//    let animation: SKAction = .group([
//      .rotate(byAngle: angleToRotate, duration: 0.3),
//      .move(to: endPoint, duration: 1)
//    ])
//    
//    return animation
//  }
  
//  private func buildCarAnimation(originPoint: Int) {
//
//  }
  
  private func moveCar(pointIdSelected: Int) {
    if pointIdSelected == actualPointId {
      return
    }
    
    self.animationRunning = true
    
    var carAnimationSequence: [SKAction] = [
      .wait(forDuration: 0.8),
      .run {
        self.coreHapticsManager?.playRumblePattern()
      }
    ]
    
    if pointIdSelected > actualPointId {
      for i in actualPointId+1...pointIdSelected {
        carAnimationSequence.append(.move(to: pointPositions[i], duration: 0.5))
      }
    } else {
      for i in (pointIdSelected...actualPointId).reversed() {
        carAnimationSequence.append(.move(to: pointPositions[i], duration: 0.5))
      }
    }
    
    carAnimationSequence.append(.run {
      self.animationRunning = false
    })
    
    car.run(.sequence(carAnimationSequence))
    
    actualPointId = pointIdSelected
  }
  
  private func runPointTouchAnimation(point: SKSpriteNode) {
    coreHapticsManager?.playTouchPattern()
    
    let animation: SKAction = .group([
      .fadeIn(withDuration: 0.6),
      .sequence([
        .scale(by: 1.2, duration: 0.3),
        .scale(by: 0.8, duration: 0.3),
      ])
    ])
    
    point.run(animation)
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if animationRunning {
      return
    }
    
    for i in 0..<discoverablePoints {
      if clickablePoints[i].contains(pos) && i < clickablePoints.count {
        moveCar(pointIdSelected: clickablePointIds[i])
        
        runPointTouchAnimation(point: clickablePoints[i])
        
        discoverablePoints += 1
        break
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

enum CarSceneCarRotationType {
  case clockwise
  case anticlockwise
}

