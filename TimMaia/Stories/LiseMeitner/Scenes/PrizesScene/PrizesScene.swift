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
  
  private lazy var textArea: SKSpriteNode = { [unowned self] in
    return childNode(withName : "textViewArea") as! SKSpriteNode
  }()
  private lazy var sceneTextView: SKSpriteNode = { [unowned self] in
    return childNode(withName : "sceneTextView") as! SKSpriteNode
  }()
  private var sceneText = SKLabelNode()
  
  private var nextButton: SKSpriteNode!
  
  private var hapticsManager: PrizesSceneHapticsManager?
  
  private var tooltipManager: TooltipManager!
  
  private var gameEnded = false
  
  static func create() -> SKScene {
    let scene = PrizesScene(fileNamed: "PrizesScene")
    scene?.hapticsManager = DefaultPrizesSceneHapticsManager()

    return scene!
  }
  
  override func didMove(to view: SKView) {
    nextButton = (self.childNode(withName: "button") as! SKSpriteNode)
    nextButton.alpha = 0
    
    fetchPrizes()
      
    startTooltip()
  }
  
  private func startTooltip() {
    if tooltipManager != nil {
      tooltipManager.stopAnimation()
    }
    
    for itemNode in prizesNodes {
      if itemNode.alpha != 0 {
        tooltipManager = TooltipManager(
          scene: self,
          startPosition: itemNode.position,
          timeBetweenAnimations: 4,
          animationType: .touch
        )
        tooltipManager.startAnimation()
        
        return
      }
    }
  }
  
  private func showSceneText() {
    tooltipManager.stopAnimation()
    
    sceneText = sceneTextView.childNode(withName: "sceneText") as! SKLabelNode
    sceneText.fontSize = 40
    sceneText.fontName = "NewYorkSmall-Semibold"
    sceneText.text = NSLocalizedString("LisePrizesScene", comment: "Comment")
    sceneText.preferredMaxLayoutWidth = textArea.frame.width
    
    let fadeIn = SKAction.fadeAlpha(to: 0.85, duration: 2)
    let wait = SKAction.wait(forDuration: 2)
    let fadeOut = SKAction.fadeAlpha(to: 0, duration: 1.5)
    let sequence: [SKAction] = [fadeIn, wait, fadeOut]

    sceneTextView.run(.sequence(sequence))
  }
  
  private func fetchPrizes() {
    for number in 0..<numberOfPrizes {
      let backNode = childNode(withName: "PrizeBack-\(number)") as? SKSpriteNode
      prizesNodes.append(backNode!)
    }
  }
  
  private func fadeNodeOut(
    node: SKSpriteNode,
    onAnimationEnd: @escaping () -> Void
  ) {
    node.run(.sequence([
      .fadeOut(withDuration: 2),
      .run {
        onAnimationEnd()
      }
    ]))
    hapticsManager?.triggerSuccess()
  }
  
  private func checkGameEnded() {
    for itemNode in prizesNodes {
      if itemNode.alpha != 0 {
        return
      }
    }
    
    gameEnded = true
    showSceneText()
    nextButton.run(.fadeIn(withDuration: 9.5))
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if gameEnded {
      if nextButton.contains(pos) {
        SceneTransition.executeDefaultTransition(
          from: self,
          to: LiseFinalScene.create(),
          nextSceneScaleMode: .aspectFill,
          transition: SKTransition.reveal(with: .left, duration: 2)
        )
      }
      
      return
    }
    
    for index in 0..<numberOfPrizes {
      let prizeBack = prizesNodes[index]
      if prizeBack.contains(pos) {
        fadeNodeOut(node: prizeBack, onAnimationEnd: {
          self.startTooltip()
          self.checkGameEnded()
        })
        
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

