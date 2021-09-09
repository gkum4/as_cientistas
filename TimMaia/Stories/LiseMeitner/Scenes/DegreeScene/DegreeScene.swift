//
//  DegreeScene.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 25/08/21.
//

import SpriteKit

private var symbols = [ "œ", "∑", "€", "®", "ŧ", "ø", "þ", "§", "•", "¶", "¬", "¢", "£", "æ", "ß", "ð", "đ", "∆", "ħ", "ʝ", "ĸ", "ł", "·", "~", "Ω", "…", "≈", "₢", "ʋ", "∫", "ŋ", "µ", "≤", "≥", ">", "<", "-", "+", "=", "/", "%", "*", "Ø", "€", "∏", "±"]

class DegreeScene: SKScene {
  private var degreeImage: SKSpriteNode!
  private var degreeKnotImage: SKSpriteNode!
  
  private var points: [PointProps] = []
  var numberOfPoints = 19
  
  let tooltip = SKShapeNode(circleOfRadius: 30)
  private var tooltipTimer: Timer!
  
  var gameEnded = false
  
  
  private var coreHapticsManager: DegreeSceneCoreHapticsManager?
  
  static func create() -> SKScene {
    let scene = DegreeScene(fileNamed: "DegreeScene")
    scene?.coreHapticsManager = DefaultDegreeSceneCoreHapticsManager()
    
    return scene!
  }
  
  override func didMove(to view: SKView) {
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
    
    startTooltipTimer()
  }
  
  func startTooltipTimer() {
    tooltipTimer = Timer.scheduledTimer(
      timeInterval: 5,
      target: self,
      selector: #selector(self.runTip),
      userInfo: nil,
      repeats: true
    )
  }
  
  @objc func runTip() {
    tooltip.position = points[0].node.position
    tooltip.fillColor = .black
    tooltip.strokeColor = .clear
    tooltip.alpha = 0.5
    
    self.addChild(tooltip)
    
    var tooltipAnimationSequence: [SKAction] = []
    
    for i in 1..<numberOfPoints/3 {
      tooltipAnimationSequence.append(.move(to: points[i].node.position, duration: 0.2))
    }
    
    tooltipAnimationSequence.append(.fadeOut(withDuration: 0.2))
    tooltipAnimationSequence.append(.run {
      self.tooltip.removeFromParent()
    })
    
    tooltip.run(.sequence(tooltipAnimationSequence))
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
          by: CGVector(dx: Int.random(in: -40...40), dy: Int.random(in: -40...40)),
          duration: 0.3
        ),
        .fadeOut(withDuration: 0.4)
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
    tooltipTimer.invalidate()
    tooltip.alpha = 0
    
    points[pointArrNumber].checked = true
    
    checkIfCompletedGame()
  }
  
  func checkIfCompletedGame() {
    for i in 0..<numberOfPoints {
      if !points[i].checked {
        startTooltipTimer()
        return
      }
    }
    
    onGameEnd()
  }
  
  func onGameEnd() {
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
      return
    }
    
    checkPoint(at: pos)
  }
  
  func touchUp(atPoint pos : CGPoint) {
    if gameEnded {
      return
    }
    
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
