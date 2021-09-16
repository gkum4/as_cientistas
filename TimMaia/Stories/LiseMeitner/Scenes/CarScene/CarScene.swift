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
  private var clickablePoints: [ClickablePoint] = []
  private var pointPositions: [CGPoint] = []
  private var whiteOverlay: SKSpriteNode!
  private var locationTextLabel: SKLabelNode!
  
  private var locationTexts = ["Denmark", "Switzerland", "Netherlands", "Stockholm, Sweden"]
  
  var clickablePointIds = [1, 5, 10, 13]
  
  var actualPointId = 0
  
  var numberOfPoints = 18
  var numberOfFishes = 3
  
  var animationRunning = false
  
  var discoverablePoints = 0
  
  var allPointsTouched = false
  
  private var coreHapticsManager: CarSceneCoreHapticsManager?
  private var tooltipManager: TooltipManager!
  
  static func create() -> SKScene {
    let scene = CarScene(fileNamed: "CarScene")
    scene?.coreHapticsManager = DefaultCarSceneCoreHapticsManager()
    
    return scene!
  }
  
  override func didMove(to view: SKView) {
    self.backgroundColor = UIColor(red: 0.95, green: 0.73, blue: 0.6, alpha: 1)
    
    car = (self.childNode(withName: "car") as! SKSpriteNode)
    
    for i in 0..<numberOfPoints {
      let positionNode = (self.childNode(withName: "point\(i)Position") as! SKSpriteNode)
      positionNode.alpha = 0
      
      pointPositions.append(
        positionNode.position
      )
      
      if i < clickablePointIds.count {
        clickablePoints.append(
          .init(node: (self.childNode(withName: "point\(i)") as! SKSpriteNode))
        )
        clickablePoints[i].node.alpha = 0.5
      }
    }
    
    for i in 0..<numberOfFishes {
      fishes.append((self.childNode(withName: "fish\(i)") as! SKSpriteNode))
      fishes[i].run(.repeatForever(.sequence([
        .rotate(byAngle: CGFloat(0.0872665*2), duration: 0.2),
        .rotate(byAngle: CGFloat(-0.0872665*2), duration: 0.2),
      ])))
    }
    
    whiteOverlay = (self.childNode(withName: "//whiteOverlay") as! SKSpriteNode)
    locationTextLabel = (self.childNode(withName: "//locationText") as! SKLabelNode)
    
    tooltipManager = TooltipManager(
      scene: self,
      startPosition: clickablePoints[0].node.position,
      timeBetweenAnimations: 5,
      animationType: .touch
    )
    
    tooltipManager.startAnimation()
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
  
  private func moveCar(pointIdSelected: Int, onAnimationEnd: @escaping () -> Void) {
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
    
    carAnimationSequence.append(.run(onAnimationEnd))
    
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
  
  private func setupTooltip() {
    if discoverablePoints == clickablePoints.count {
      tooltipManager.stopAnimation()
      return
    }
    
    self.tooltipManager = TooltipManager(
      scene: self,
      startPosition: clickablePoints[discoverablePoints].node.position,
      timeBetweenAnimations: 5,
      animationType: .touch
    )
  }
  
  private func updateDiscoverablePoints() {
    var result = 0
    
    for point in clickablePoints {
      if point.clicked {
        result += 1
      }
    }
    
    if result == clickablePoints.count {
      allPointsTouched = true
    }
    
    discoverablePoints = result
  }
  
  private func showLocationTextAnimation(id: Int, onAnimationEnd: @escaping () -> Void ) {
    locationTextLabel.text = locationTexts[id]
    
    let whiteOverlayAnimationSequence: SKAction = .sequence([
      .fadeAlpha(by: 0.8, duration: 0.5),
      .wait(forDuration: 1.2),
      .fadeOut(withDuration: 0.5),
      .run {
        onAnimationEnd()
      }
    ])
    
    whiteOverlay.run(whiteOverlayAnimationSequence)
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if animationRunning {
      return
    }
    
    for i in 0...discoverablePoints {
      if clickablePoints[i].node.contains(pos) && i < clickablePoints.count {
        clickablePoints[i].clicked = true
        
        updateDiscoverablePoints()
        
        self.animationRunning = true
        allPointsTouched ? nil : tooltipManager.stopAnimation()
        
        setupTooltip()
        
        if clickablePointIds[i] != actualPointId {
          moveCar(
            pointIdSelected: clickablePointIds[i],
            onAnimationEnd: {
              self.showLocationTextAnimation(id: i, onAnimationEnd: {
                self.allPointsTouched ? nil : self.tooltipManager.startAnimation()
                self.animationRunning = false
              })
            }
          )
        } else {
          showLocationTextAnimation(id: i, onAnimationEnd: {
            self.allPointsTouched ? nil : self.tooltipManager.startAnimation()
            self.animationRunning = false
          })
        }
        
        runPointTouchAnimation(point: clickablePoints[i].node)
        
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

