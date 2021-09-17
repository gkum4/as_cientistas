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
  
  private var tooltipManager: TooltipManager!
  
  private var canGoToNextScene = false
  
  static func create() -> SKScene {
    let scene = NewsScene(fileNamed: "NewsScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    tooltipManager = TooltipManager(
      scene: self,
      startPosition: CGPoint(x: 0, y: 0),
      timeBetweenAnimations: 5,
      animationType: .touch
    )
    tooltipManager.startAnimation()
    
    setupText()
  }
  
  private func setupText() {
    fstPageText = firstPage.childNode(withName: "NewsText-0") as! SKLabelNode
    scdPageTextLeft = secondPage.childNode(withName: "NewsText-1") as! SKLabelNode

    fstPageText.fontName = "NewYorkSmall-Semibold"
    fstPageText.fontSize = 45
    fstPageText.text = "Otto wins \nthe Nobel \nPrize in \nChemistry"
    
    scdPageTextLeft.fontName = "NewYorkSmall-Regular"
    scdPageTextLeft.text = "The German \nchemist Otto Hahn, \nwas recognized for \ndiscovering the \nprocess of nuclear \nfission. \n\nHe was grateful for \nthe recognition of \nhis research and did not mention other \nparticipants who influenced this \nachievement, such as the physicist \nLise Weitmer, who was actually \nresponsible for the research \nand discovery."
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if canGoToNextScene {
      SceneTransition.executeDefaultTransition(
        from: self,
        to: LiseHelpsOttoScene.create(),
        nextSceneScaleMode: .aspectFill,
        transition: SKTransition.push(with: .down, duration: 2)
      )
    }
    
    if firstPage.contains(pos) {
      tooltipManager.stopAnimation()
      firstPage.run(.fadeOut(withDuration: 2))
      secondPage.run(.sequence([
        .fadeIn(withDuration: 2),
        .run {
          self.canGoToNextScene = true
        }
      ]))
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
