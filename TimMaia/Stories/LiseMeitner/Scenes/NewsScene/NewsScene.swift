//
//  NewsScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 15/09/21.
//

import SpriteKit

class NewsScene: SKScene {
  private lazy var firstPage: SKSpriteNode = { [unowned self] in
    return childNode(withName : "News-0") as! SKSpriteNode
  }()
  private lazy var secondPage: SKSpriteNode = { [unowned self] in
    return childNode(withName : "News-1") as! SKSpriteNode
  }()
  
  private lazy var fstTextArea: SKSpriteNode = { [unowned self] in
    return childNode(withName : "TextAreaNews-0") as! SKSpriteNode
  }()
  private lazy var scdTextAreaLeft: SKSpriteNode = { [unowned self] in
    return childNode(withName : "TextAreaNews-1") as! SKSpriteNode
  }()
  private lazy var scdTextAreaRight: SKSpriteNode = { [unowned self] in
    return childNode(withName : "TextAreaNews-2") as! SKSpriteNode
  }()

  private var fstPageText = SKLabelNode()
  private var scdPageTextLeft = SKLabelNode()
  private var scdPageTextRight = SKLabelNode()
  
  static func create() -> SKScene {
    let scene = NewsScene(fileNamed: "NewsScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    setupText()
  }
  
  private func setupText() {
    fstPageText.text = "Otto wins the Nobel Prize in Chemistry"
    fstPageText.fontSize = 45
    fstPageText.numberOfLines = 0
    fstPageText.zPosition = 1

    fstPageText.fontName = "NewYorkSmall-Semibold"
    fstPageText.fontColor = .black
    fstPageText.position = fstTextArea.position
    fstPageText.zRotation = fstTextArea.zRotation
    fstPageText.preferredMaxLayoutWidth = fstTextArea.frame.width
    addChild(fstPageText)
    
    scdPageTextLeft.text = "The German chemist Otto Hahn, was recognized for discovering the process of nuclear fission. \n\nHe was grateful for the recognition of his research and did not mention other participants who influenced this achievement,"
    scdPageTextLeft.numberOfLines = 0
    scdPageTextLeft.zPosition = 1
    scdPageTextLeft.alpha = 0
    scdPageTextLeft.fontColor = .black
    scdPageTextLeft.fontName = "NewYorkSmall-Semibold"
    scdPageTextLeft.position = scdTextAreaLeft.position
    scdPageTextLeft.preferredMaxLayoutWidth = scdTextAreaLeft.frame.width
    addChild(scdPageTextLeft)
    
    scdPageTextRight.text = "such as the physicist Lise Weitmer, who was actually responsible for the research and discovery."
    scdPageTextRight.numberOfLines = 0
    scdPageTextRight.zPosition = 1
    scdPageTextRight.alpha = 0
    scdPageTextRight.fontColor = .black
    scdPageTextRight.fontName = "NewYorkSmall-Semibold"
    scdPageTextRight.position = scdTextAreaRight.position
    scdPageTextRight.preferredMaxLayoutWidth = scdTextAreaRight.frame.width
    addChild(scdPageTextRight)
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if firstPage.contains(pos) {
      firstPage.run(.fadeOut(withDuration: 2))
      fstPageText.run(.fadeOut(withDuration: 1.5))

      secondPage.run(.fadeIn(withDuration: 2))
      scdPageTextLeft.run(.fadeIn(withDuration: 2))
      scdPageTextRight.run(.fadeIn(withDuration: 2))
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
