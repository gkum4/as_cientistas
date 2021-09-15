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
    fstPageText = firstPage.childNode(withName: "NewsText-0") as! SKLabelNode
    scdPageTextLeft = secondPage.childNode(withName: "NewsText-1") as! SKLabelNode
    scdPageTextRight = secondPage.childNode(withName: "NewsText-2") as! SKLabelNode

    fstPageText.text = "Desta maneira, a \n lorem ipsum sit \n dolor amet kaka \n sit dolor again"
    
    scdPageTextLeft.text = "Desta maneira, a \n lorem ipsum sit \n dolor amet kaka \n sit dolor again \n Desta maneira, a \n lorem ipsum sit \n dolor amet kaka \n sit dolor again \n Desta maneira, a \n lorem ipsum sit \n dolor amet kaka \n sit dolor again \n Desta maneira, a \n lorem ipsum sit \n dolor amet kaka \n sit dolor again \n "
    
    scdPageTextRight.text = "Desta maneira, a \n lorem ipsum sit \n dolor amet kaka \n sit dolor again"
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if firstPage.contains(pos) {
      firstPage.run(.fadeOut(withDuration: 2))
      secondPage.run(.fadeIn(withDuration: 2))
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
