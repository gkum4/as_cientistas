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
  
  var gameEnded = false
  
  var textAnimationEnded = false
  
  private var nextButton: SKSpriteNode!
  
  private var symbolsManager: SymbolsManager!
  private var tooltipManager: TooltipManager!
  private var coreHapticsManager: DegreeSceneCoreHapticsManager?
  
  static func create() -> SKScene {
    let scene = DegreeScene(fileNamed: "DegreeScene")
    scene?.coreHapticsManager = DefaultDegreeSceneCoreHapticsManager()
    
    return scene!
  }
  
  override func didMove(to view: SKView) {
    self.backgroundColor = UIColor(named: "Areia")!
    
    nextButton = (self.childNode(withName: "button") as! SKSpriteNode)
    nextButton.alpha = 0
    
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
    
    symbolsManager = SymbolsManager(scene: self)
    
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
  
  func checkPoint(at pos: CGPoint) {
    for i in 0..<numberOfPoints {
      if points[i].node.contains(pos) {
        coreHapticsManager?.playMovePattern()
        symbolsManager.generateAnimatedSymbol(at: pos)
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
  
  func showDegreeText() {
    let titleTextManager = DynamicTextManager(
      text: NSLocalizedString("LiseDegreeScene1", comment: "Comment"),
      startPos: CGPoint(x: -207, y: 260),
      textWidth: 430,
      lineHeight: 60,
      fontStyle: .init(fontName: "NewYorkSmall-Bold", fontSize: 36, color: .black)
    )
    
    let textManager = DynamicTextManager(
      text: NSLocalizedString("LiseDegreeScene2", comment: "Comment"),
      startPos: CGPoint(x: -207, y: 100),
      textWidth: 430,
      lineHeight: 60,
      fontStyle: .init(fontName: "NewYorkSmall-Regular", fontSize: 32, color: .black)
    )
    
    var textAnimationSequence: [SKAction] = []
    
    let charNodeAnimation: SKAction = .group([
      .scale(by: 0.8, duration: 0.2),
      .fadeIn(withDuration: 0.2)
    ])
    
    for charNode in titleTextManager.lettersNodes {
      textAnimationSequence.append(.run {
        self.addChild(charNode)
        charNode.setScale(1.2)
        
        charNode.run(charNodeAnimation)
        
        self.symbolsManager.generateAnimatedSymbol(at: charNode.position)
      })
      textAnimationSequence.append(.wait(forDuration: 0.1))
    }
    
    for charNode in textManager.lettersNodes {
      textAnimationSequence.append(.run {
        self.addChild(charNode)
        charNode.setScale(1.2)
        
        charNode.run(charNodeAnimation)
        
        self.symbolsManager.generateAnimatedSymbol(at: charNode.position)
      })
      textAnimationSequence.append(.wait(forDuration: 0.1))
    }
    
    textAnimationSequence.append(.run {
      self.nextButton.run(.sequence([
        .fadeIn(withDuration: 1),
        .run {
          self.textAnimationEnded = true
        }
      ]))
    })
    
    self.run(.sequence(textAnimationSequence))
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
    
    degreeAnimationSequence.append(.run {
      self.showDegreeText()
    })
    
    degreeKnotImage.run(degreeKnotAnimation)
    
    degreeImage.run(.sequence(degreeAnimationSequence))
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if gameEnded {
      if textAnimationEnded && nextButton.contains(pos) {
        SceneTransition.executeDefaultTransition(
          from: self,
          to: ChemistryInstituteScene.create(),
          nextSceneScaleMode: .aspectFill,
          transition: .push(with: .down, duration: 2)
        )
      }
      return
    }
    
    checkPoint(at: pos)
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    if gameEnded {
      symbolsManager.generateAnimatedSymbol(at: pos)
      return
    }
    
    checkPoint(at: pos)
  }
  
  func touchUp(atPoint pos : CGPoint) {
    if gameEnded {
      print(pos)
      return
    }
    
    if checkIfCompletedGame() {
      tooltipManager.stopAnimation()
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
