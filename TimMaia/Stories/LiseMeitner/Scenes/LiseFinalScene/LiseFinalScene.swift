//
//  LiseFinalScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 15/09/21.
//

import SpriteKit

class LiseFinalScene: SKScene {
  private var text1 = DynamicTextManager(
    text: NSLocalizedString("LiseFinalScene1", comment: "Comment"),
    startPos: CGPoint(x: -220, y: -10),
    textWidth: 440,
    spacing: 4,
    textRotation: 0.1,
    fontStyle: BasicFontStyle(
      fontName: "NewYorkSmall-Regular",
      fontSize: 35,
      color: .black
    )
  )
  
  private var text2 = DynamicTextManager(
    text: NSLocalizedString("LiseFinalScene2", comment: "Comment"),
    startPos: CGPoint(x: -100, y: -100),
    textWidth: 360,
    spacing: 6,
    textRotation: 0.1,
    fontStyle: BasicFontStyle(
      fontName: "NewYorkSmall-Regular",
      fontSize: 35,
      color: .black
    )
  )
  
  private var text3 = DynamicTextManager(
    text: NSLocalizedString("LiseFinalScene3", comment: "Comment"),
    startPos: CGPoint(x: -200, y: -270),
    textWidth: 420,
    spacing: 4,
    textRotation: 0.1,
    fontStyle: BasicFontStyle(
      fontName: "NewYorkSmall-Regular",
      fontSize: 35,
      color: .black
    )
  )
  
  private var text4 = DynamicTextManager(
    text: NSLocalizedString("LiseFinalScene4", comment: "Comment"),
    startPos: CGPoint(x: 0, y: -380),
    textWidth: 360,
    spacing: 6,
    textRotation: 0.1,
    fontStyle: BasicFontStyle(
      fontName: "NewYorkSmall-Regular",
      fontSize: 35,
      color: .black
    )
  )
  
  private var textSize: Int?
  private var textNodes = [SKLabelNode]()
  
  private var replayButton: SKLabelNode!
  
  private var tooltipManager: TooltipManager!
  private var symbolsManager: SymbolsManager!
  private var gameEnded = false
  
  static func create() -> SKScene {
    let scene = LiseFinalScene(fileNamed: "LiseFinalScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    self.backgroundColor = .systemBackground
    
    replayButton = (self.childNode(withName: "replayButton") as! SKLabelNode)
    replayButton.alpha = 0
    replayButton.fontName = "NewYorkSmall-Semibold"
    
    tooltipManager = TooltipManager(
      scene: self,
      startPosition: CGPoint(x: -200, y: 0),
      timeBetweenAnimations: 5,
      animationType: .slideToRight
    )
    
    symbolsManager = SymbolsManager(scene: self)
    
    tooltipManager.startAnimation()

    setupText()
  }
  
  private func setupText() {
    textSize = text1.textSize + text2.textSize + text3.textSize + text4.textSize
    
    textNodes = text1.lettersNodes
    textNodes.append(contentsOf: text2.lettersNodes)
    textNodes.append(contentsOf: text3.lettersNodes)
    textNodes.append(contentsOf: text4.lettersNodes)
    
    for node in textNodes {
      node.fontColor = .white
      node.alpha = 1
      addChild(node)
    }
  }
  
  private func checkEndedGame() {
    var count = 0
    
    for charNode in textNodes {
      if charNode.alpha != 0 {
        count += 1
      }
    }
    
    if count >= textNodes.count-4 {
      gameEnded = true
      replayButton.run(.repeatForever(.sequence([
        .fadeIn(withDuration: 1),
        .wait(forDuration: 3),
        .fadeOut(withDuration: 0.5)
      ])))
    }
  }
  
  func touchDown(atPoint pos : CGPoint) {
    tooltipManager.stopAnimation()
    
    if gameEnded && replayButton.contains(pos) {
      SceneTransition.executeDefaultTransition(
        from: self,
        to: MapZoomScene.create(),
        nextSceneScaleMode: .aspectFill,
        transition: SKTransition.doorsCloseVertical(withDuration: 2)
      )
    }
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    symbolsManager.generateAnimatedSymbol(at: pos)
    
    for i in 1..<textSize!-1 {
      if textNodes[i].contains(pos) {
        textNodes[i - 1].run(SKAction.fadeIn(withDuration: 0.7))
        textNodes[i].run(SKAction.fadeIn(withDuration: 0.7))
        textNodes[i + 1].run(SKAction.fadeIn(withDuration: 0.7))
        checkEndedGame()
        break
      }
    }
  }
  
  func touchUp(atPoint pos : CGPoint) {
    if gameEnded {
      return
    }
    
    tooltipManager.startAnimation()
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

