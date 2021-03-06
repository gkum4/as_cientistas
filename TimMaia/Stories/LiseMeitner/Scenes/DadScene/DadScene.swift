//
//  DadScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 12/09/21.
//

import SpriteKit

class DadScene: SKScene {
  private lazy var badge: SKLabelNode = { [unowned self] in
    return childNode(withName : "DadBadge") as! SKLabelNode
  }()
  private var dadSpeech = DynamicTextManager(
    text: NSLocalizedString("LiseDadScene2", comment: "Comment"),
    startPos: CGPoint(x: -225, y: -275),
    textWidth: 460,
    lineHeight: 100,
    textRotation: 0.2,
    fontStyle: .init(
      fontName: "NewYorkSmall-Medium",
      fontSize: 36,
      color: .black
    )
  )
  
  private var completedGame = false
  
  private var nextButton: SKSpriteNode!
  
  private var tooltipManager1: TooltipManager!
  private var tooltipManager2: TooltipManager!
  private var symbolsManager: SymbolsManager!
  
  private var textSize: Int?
  private var textNodes = [SKLabelNode]()
  
  static func create() -> SKScene {
    let scene = DadScene(fileNamed: "DadScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    nextButton = (self.childNode(withName: "button") as! SKSpriteNode)
    nextButton.alpha = 0
    
    badge.text = NSLocalizedString("LiseDadScene1", comment: "Comment")
    
    textSize = dadSpeech.textSize
    textNodes = dadSpeech.lettersNodes
    for node in textNodes {
      addChild(node)
    }
    
    symbolsManager = SymbolsManager(scene: self)
    
    tooltipManager1 = TooltipManager(
      scene: self,
      startPosition: CGPoint(x: -130, y: -250),
      timeBetweenAnimations: 5,
      animationType: .slideToRight
    )
    
    tooltipManager1.startAnimation()
  }
  
  func checkIfCompletedGame() {
    var result = 0
    
    for charNode in textNodes {
      if charNode.alpha != 0 {
        result += 1
      }
    }
    
    if result >= textNodes.count/2 {
      showAllChars()
      onGameEnd()
    }
  }
  
  private func showAllChars() {
    for charNode in textNodes {
      if charNode.alpha != 1 {
        charNode.run(.fadeIn(withDuration: 1.5))
      }
    }
  }
  
  func onGameEnd() {
    completedGame = true
    tooltipManager1.stopAnimation()
    nextButton.run(.fadeIn(withDuration: 1.5))
  }
  
  func touchDown(atPoint pos : CGPoint) {
    tooltipManager1.stopAnimation()
    
    if completedGame {
      if nextButton.contains(pos) {
        SceneTransition.executeDefaultTransition(
          from: self,
          to: LiseWithBoysScene.create(),
          nextSceneScaleMode: .aspectFill,
          transition: SKTransition.flipVertical(withDuration: 2)
        )
      }
      
      return
    }
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    symbolsManager.generateAnimatedSymbol(at: pos)
    
    for i in 1..<textSize!-1 {
      if textNodes[i].contains(pos) {
        textNodes[i - 1].run(SKAction.fadeIn(withDuration: 0.7))
        textNodes[i].run(SKAction.fadeIn(withDuration: 0.7))
        textNodes[i + 1].run(SKAction.fadeIn(withDuration: 0.7))
        
        checkIfCompletedGame()
        break
      }
    }
  }
  
  func touchUp(atPoint pos : CGPoint) {
    if completedGame {
      return
    }
    
    tooltipManager1.startAnimation()
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
