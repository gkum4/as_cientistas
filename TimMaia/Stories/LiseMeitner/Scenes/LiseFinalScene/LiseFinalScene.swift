//
//  LiseFinalScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 15/09/21.
//

import SpriteKit

class LiseFinalScene: SKScene {
  private var dynamicsTexts = [
    DynamicTextManager(
      text: NSLocalizedString("LiseFinalScene1", comment: "Comment"),
      startPos: CGPoint(x: -220, y: -10),
      textWidth: 480,
      spacing: 4,
      textRotation: 0.1,
      fontStyle: BasicFontStyle(
        fontName: "NewYorkSmall-Regular",
        fontSize: 35,
        color: .black
      )
    ),
    DynamicTextManager(
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
    ),
    DynamicTextManager(
      text: NSLocalizedString("LiseFinalScene3", comment: "Comment"),
      startPos: CGPoint(x: -220, y: -270),
      textWidth: 460,
      spacing: 4,
      textRotation: 0.1,
      fontStyle: BasicFontStyle(
        fontName: "NewYorkSmall-Regular",
        fontSize: 35,
        color: .black
      )
    ),
    DynamicTextManager(
      text: NSLocalizedString("LiseFinalScene4", comment: "Comment"),
      startPos: CGPoint(x: -60, y: -380),
      textWidth: 360,
      spacing: 6,
      textRotation: 0.1,
      fontStyle: BasicFontStyle(
        fontName: "NewYorkSmall-Regular",
        fontSize: 35,
        color: .black
      )
    )
  ]
  
  private var textSizes = [Int]()
  private var totalNodes = 0
  private var textNodes = [[SKLabelNode]]()
  
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
    replayButton.text = NSLocalizedString("LiseFinalScene5", comment: "Comment")
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
    for text in dynamicsTexts {
      textSizes.append(text.textSize)
      textNodes.append(text.lettersNodes)
    }
    
    for nodes in textNodes {
      totalNodes += nodes.count
      for item in nodes {
        item.fontColor = .white
        addChild(item)
      }
    }
  }
  
  private func checkEndedGame() {
    var count = 0
    
    for totalText in 0..<textSizes.count {
      for i in 0..<textSizes[totalText] {
        if textNodes[totalText][i].alpha != 0 {
          count += 1
        }
      }
    }
    
    if count >= totalNodes-4 {
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
    
    for totalText in 0..<textSizes.count {
      for i in 1..<textSizes[totalText]-1 {
        if textNodes[totalText][i].contains(pos) {
          textNodes[totalText][i - 1].run(SKAction.fadeIn(withDuration: 1))
          textNodes[totalText][i].run(SKAction.fadeIn(withDuration: 1))
          textNodes[totalText][i + 1].run(SKAction.fadeIn(withDuration: 1))
          checkEndedGame()
          break
        }
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

