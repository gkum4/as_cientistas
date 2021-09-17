//
//  LiseFinalScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 15/09/21.
//

import SpriteKit

class LiseFinalScene: SKScene {
  private var text1 = DynamicTextManager(text: "Life does not have",
                                    startPos: CGPoint(x: -200, y: -10),
                                    textWidth: 420, spacing: 4, textRotation: 0.1,
                                    fontStyle: BasicFontStyle(fontName: "NewYorkSmall-Regular", fontSize: 35, color: .black))
  
  private var text2 = DynamicTextManager(text: "to be easy",
                                    startPos: CGPoint(x: -100, y: -100),
                                    textWidth: 360, spacing: 6, textRotation: 0.1,
                                    fontStyle: BasicFontStyle(fontName: "NewYorkSmall-Regular", fontSize: 35, color: .black))
  
  private var text3 = DynamicTextManager(text: "as long it has not",
                                    startPos: CGPoint(x: -200, y: -270),
                                    textWidth: 420, spacing: 4, textRotation: 0.1,
                                    fontStyle: BasicFontStyle(fontName: "NewYorkSmall-Regular", fontSize: 35, color: .black))
  
  private var text4 = DynamicTextManager(text: "been empty",
                                    startPos: CGPoint(x: 0, y: -380),
                                    textWidth: 360, spacing: 6, textRotation: 0.1,
                                    fontStyle: BasicFontStyle(fontName: "NewYorkSmall-Regular", fontSize: 35, color: .black))

  private var dynamicsTexts = [
    DynamicTextManager(text: "Life does not have",
                                      startPos: CGPoint(x: -200, y: -10),
                                      textWidth: 420, spacing: 4, textRotation: 0.1,
                                      fontStyle: BasicFontStyle(fontName: "NewYorkSmall-Regular", fontSize: 35, color: .black)),
    DynamicTextManager(text: "to be easy",
                                      startPos: CGPoint(x: -100, y: -100),
                                      textWidth: 360, spacing: 6, textRotation: 0.1,
                                      fontStyle: BasicFontStyle(fontName: "NewYorkSmall-Regular", fontSize: 35, color: .black)),
    DynamicTextManager(text: "as long it has not",
                                      startPos: CGPoint(x: -200, y: -270),
                                      textWidth: 420, spacing: 4, textRotation: 0.1,
                                      fontStyle: BasicFontStyle(fontName: "NewYorkSmall-Regular", fontSize: 35, color: .black)),
    DynamicTextManager(text: "been empty",
                                      startPos: CGPoint(x: 0, y: -380),
                                      textWidth: 360, spacing: 6, textRotation: 0.1,
                                      fontStyle: BasicFontStyle(fontName: "NewYorkSmall-Regular", fontSize: 35, color: .black))
  ]
  
  private var textSizes = [Int]()
  private var textNodes = [[SKLabelNode]]()
  
  static func create() -> SKScene {
    let scene = LiseFinalScene(fileNamed: "LiseFinalScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    self.backgroundColor = .systemBackground

    setupText()
  }
  
  private func setupText() {
    for text in dynamicsTexts {
      textSizes.append(text.textSize)
      textNodes.append(text.lettersNodes)
    }
    
    for nodes in textNodes {
      for item in nodes {
        item.fontColor = .white
        addChild(item)
      }
    }
  }
  
  func touchDown(atPoint pos : CGPoint) {
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    for totalText in 0..<textSizes.count {
      for i in 1..<textSizes[totalText]-1 {
        if textNodes[totalText][i].contains(pos) {
          textNodes[totalText][i - 1].run(SKAction.fadeIn(withDuration: 1))
          textNodes[totalText][i].run(SKAction.fadeIn(withDuration: 1))
          textNodes[totalText][i + 1].run(SKAction.fadeIn(withDuration: 1))
        }
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

