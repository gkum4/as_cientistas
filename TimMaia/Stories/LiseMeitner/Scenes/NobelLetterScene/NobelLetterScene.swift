//
//  OttoLetterScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 15/09/21.
//

import SpriteKit

class NobelLetterScene: SKScene {
  private var currentPage = 0
  private var letterPages = [
    "Hi, I'm physicist Lise Meitner. I discovered the nuclear fission process by proving that the",
    "splitting of the Uranium atom (into Barium and Krypton atoms) releases energy and neutrons,",
    "which in turn cause fission in more atoms releasing more neutrons and so on, creating a series",
    "of nuclear  fissions with continuous release of energy, in a process called chain reaction."
  ]
  
  private var text = DynamicTextManager(text: "Hi, I'm physicist Lise Meitner. I discovered the nuclear fission process by proving that the",
                                    startPos: CGPoint(x: -220, y: 470),
                                    textWidth: 440, lineHeight: 115, textRotation: 0.1,
                                    fontStyle: BasicFontStyle(fontName: "NewYorkSmall-Regular", fontSize: 30, color: .black))
  
  
  private lazy var button: SKSpriteNode = { [unowned self] in
    return childNode(withName : "Button") as! SKSpriteNode
  }()

  
  private var textSize: Int?
  private var textNodes = [SKLabelNode]()
  
  static func create() -> SKScene {
    let scene = NobelLetterScene(fileNamed: "NobelLetterScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    self.backgroundColor = .systemBackground

    textSize = text.textSize
    textNodes = text.lettersNodes
    for node in textNodes {
      node.alpha = 1
      addChild(node)
    }
  }
  
  private func changeLetterText() {
    currentPage += 1
    
    let newNodes = DynamicTextManager(text: letterPages[currentPage],
                                      startPos: CGPoint(x: -220, y: 470),
                                      textWidth: 440, lineHeight: 115, textRotation: 0.1,
                                      fontStyle: BasicFontStyle(fontName: "NewYorkSmall-Regular", fontSize: 30, color: .black))
    
    for node in newNodes.lettersNodes {
      node.run(.fadeIn(withDuration: 2.5))
      addChild(node)
    }
    
    for node in textNodes {
      node.run(.fadeOut(withDuration: 1))
    }
    
    textNodes = newNodes.lettersNodes
    textSize = newNodes.textSize
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if button.contains(pos) {
      changeLetterText()
    }
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    for i in 1..<textSize!-1 {
      if textNodes[i].contains(pos) {
        textNodes[i - 1].run(SKAction.fadeIn(withDuration: 1))
        textNodes[i].run(SKAction.fadeIn(withDuration: 1))
        textNodes[i + 1].run(SKAction.fadeIn(withDuration: 1))
      }
    }
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

