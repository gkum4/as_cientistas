//
//  DegreeScene.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 25/08/21.
//

import SpriteKit

private var symbols = [ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "∑", "π", "∆", "Ω", "√", "ƒ", "∫", "µ", "ß", "∂", "ø", "∞", "ﬁ", "ϕ", "∏"]

class DegreeScene: SKScene {
  private var degreeImage: SKSpriteNode!
  private var degreeKnotImage: SKSpriteNode!
  
  private var points: [PointProps] = []
  var numberOfPoints = 19
  
  var tooltipManager: TooltipManager!
  
  var gameEnded = false
  
  private var coreHapticsManager: DegreeSceneCoreHapticsManager?
  
  static func create() -> SKScene {
    let scene = DegreeScene(fileNamed: "DegreeScene")
    scene?.coreHapticsManager = DefaultDegreeSceneCoreHapticsManager()
    
    return scene!
  }
  
  override func didMove(to view: SKView) {
    self.backgroundColor = UIColor(named: "Areia")!
    
    for i in 0..<numberOfPoints {
      let newPoint = PointProps(
        checked: false,
        node: self.childNode(withName: "//point\(i)") as! SKSpriteNode
      )
      
      newPoint.node.alpha = 0
      
      points.append(newPoint)
    }
    
    degreeImage = self.childNode(withName: "//degree") as? SKSpriteNode
    degreeKnotImage = self.childNode(withName: "//degreeKnot") as? SKSpriteNode
    
    tooltipManager = TooltipManager(
      scene: self,
      startPosition: points[numberOfPoints/4].node.position,
      timeBetweenAnimations: 5,
      animationType: .custom
    )
    
    buildTooltipAnimation()
    
    tooltipManager.startAnimation()
  }
  
  private func buildTooltipAnimation() {
    var positions: [CGPoint] = []
    
    for i in (0...numberOfPoints/4).reversed() {
      positions.append(points[i].node.position)
    }
    
    tooltipManager.buildCustomAction(positions: positions, timeBetweenPositions: 0.2)
  }
  
  func clearPoints() {
    for i in 0..<numberOfPoints {
      points[i].checked = false
    }
  }
  
  func generateSymbol(at pos: CGPoint) {
    let symbol = SKLabelNode()
    symbol.text = symbols[Int.random(in: 0..<symbols.count)]
    symbol.position = pos
    
    self.addChild(symbol)
    
    let symbolAnimation: SKAction = .sequence([
      .group([
        .move(
          by: CGVector(dx: Int.random(in: -70...70), dy: Int.random(in: -70...70)),
          duration: 0.3
        ),
        .fadeOut(withDuration: 0.7)
      ]),
      .run {
        symbol.removeFromParent()
      }
    ])
    
    symbol.run(symbolAnimation)
  }
  
  func checkPoint(at pos: CGPoint) {
    for i in 0..<numberOfPoints {
      if points[i].node.contains(pos) {
        coreHapticsManager?.playMovePattern()
        generateSymbol(at: pos)
        onPointCheck(i)
        return
      }
    }
  }
  
  func onPointCheck(_ pointArrNumber: Int) {
    tooltipManager.stopAnimation()
    
    points[pointArrNumber].checked = true
  }
  
  func checkIfCompletedGame() -> Bool {
    var counter = 0
    
    for i in 0..<numberOfPoints {
      if points[i].checked {
        counter += 1
      }
    }
    
    if counter > numberOfPoints/4 {
      return true
    }
    
    return false
  }
  
  func onGameEnd() {
    tooltipManager.stopAnimation()
    gameEnded = true
    
    let degreeKnotAnimation: SKAction = .group([
      .scale(by: 1.3, duration: 2),
      .sequence([
        .rotate(byAngle: 0.0872665, duration: 0.1),
        .rotate(byAngle: CGFloat(-0.0872665*2), duration: 0.1),
        .rotate(byAngle: CGFloat(0.0872665), duration: 0.1)
      ]),
      .fadeOut(withDuration: 2.5)
    ])
    
    var degreeAnimationSequence: [SKAction] = []
    degreeAnimationSequence.append(.wait(forDuration: 2.5))
    degreeAnimationSequence.append(.move(by: CGVector(dx: 0, dy: 330), duration: 1.5))
    degreeAnimationSequence.append(.wait(forDuration: 0.5))
    
    for i in 4...17 {
      degreeAnimationSequence.append(.run {
        self.degreeImage.texture = SKTexture(imageNamed: "Cena_6-\(i)")
      })
      degreeAnimationSequence.append(.wait(forDuration: 0.17))
    }
    
    degreeKnotImage.run(degreeKnotAnimation)
    
    degreeImage.run(.sequence(degreeAnimationSequence))
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if gameEnded {
      return
    }
    
    checkPoint(at: pos)
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    if gameEnded {
      generateSymbol(at: pos)
      return
    }
    
    checkPoint(at: pos)
  }
  
  func touchUp(atPoint pos : CGPoint) {
    if gameEnded {
      return
    }
    
    if checkIfCompletedGame() {
      onGameEnd()
      return
    }
    
    tooltipManager.startAnimation()
    clearPoints()
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
