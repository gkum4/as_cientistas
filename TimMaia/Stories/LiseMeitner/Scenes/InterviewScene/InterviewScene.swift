//
//  InterviewScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 15/09/21.
//

import SpriteKit

class InterviewScene: SKScene {
  private lazy var televisionOff: SKSpriteNode = { [unowned self] in
    return childNode(withName : "TelevisionOff") as! SKSpriteNode
  }()
  private lazy var televisionOn: SKSpriteNode = { [unowned self] in
    return childNode(withName : "TelevisionOn") as! SKSpriteNode
  }()
  private lazy var clickableArea: SKSpriteNode = { [unowned self] in
    return childNode(withName : "TelevisionButtonArea") as! SKSpriteNode
  }()
  private lazy var televisionTextArea: SKSpriteNode = { [unowned self] in
    return childNode(withName : "TelevisionTextArea") as! SKSpriteNode
  }()
  
  
  private var isTvOn: Bool = false
  
  private var conversationNodes = [SKLabelNode]()
  private var conversation: [String] = [
    NSLocalizedString("LiseInterviewScene1", comment: "Comment"),
    NSLocalizedString("LiseInterviewScene2", comment: "Comment"),
    NSLocalizedString("LiseInterviewScene3", comment: "Comment"),
    NSLocalizedString("LiseInterviewScene4", comment: "Comment"),
    NSLocalizedString("LiseInterviewScene5", comment: "Comment"),
    NSLocalizedString("LiseInterviewScene6", comment: "Comment"),
  ]
  
  private var nextButton: SKSpriteNode!
  private var talkEnded = false
  
  private var tooltipManager: TooltipManager!
  
  static func create() -> SKScene {
    let scene = InterviewScene(fileNamed: "InterviewScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    nextButton = (self.childNode(withName: "button") as! SKSpriteNode)
    nextButton.alpha = 0
    
    tooltipManager = TooltipManager(
      scene: self,
      startPosition: CGPoint(x: clickableArea.position.x, y: clickableArea.position.y-28),
      timeBetweenAnimations: 5,
      animationType: .touch
    )
    
    tooltipManager.startAnimation()
    
    setupConversation()
  }
  
  private func setupConversation() {
    for line in conversation {
      
      let label = SKLabelNode(text: line)
      label.position = televisionTextArea.position
      label.preferredMaxLayoutWidth = televisionTextArea.frame.width
      label.alpha = 0
      label.numberOfLines = 0
      label.fontColor = .black
      label.fontName = "NewYorkSmall-Regular"
      label.fontSize = 40
      
      conversationNodes.append(label)
      addChild(label)
    }
  }
  
  private func animateConversation() {
    for (index, node) in conversationNodes.enumerated() {
      let aditionalTime = 6 * Double(index)
      
      let beginAfter = SKAction.wait(forDuration: aditionalTime)
      let fadeIn = SKAction.fadeIn(withDuration: 1)
      let wait = SKAction.wait(forDuration: 4)
      let fadeOut = SKAction.fadeOut(withDuration: 1)
      var sequence: [SKAction] = [beginAfter, fadeIn, wait, fadeOut]
      
      if index == conversationNodes.count-1 {
        sequence.append(.wait(forDuration: 1))
        sequence.append(.run {
          self.nextButton.run(.fadeIn(withDuration: 1.5))
          self.talkEnded = true
        })
      }
      
      node.run(.sequence(sequence))
    }
  }
  
  private func turnTvOn() {
    televisionOff.alpha = 0
    isTvOn = true

    animateConversation()
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if talkEnded && nextButton.contains(pos) {
      SceneTransition.executeDefaultTransition(
        from: self,
        to: LiseTeachingScene.create(),
        nextSceneScaleMode: .aspectFill,
        transition: SKTransition.fade(withDuration: 2)
      )
    }
    
    if !isTvOn && clickableArea.contains(pos) {
      tooltipManager.stopAnimation()
      turnTvOn()
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
