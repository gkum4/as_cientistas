//
//  SymbolsManager.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 15/09/21.
//

import SpriteKit

class SymbolsManager {
  private var scene: SKScene
  private var color: UIColor
  
  private var symbols = [ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "∑", "π", "∆", "Ω", "√", "ƒ", "∫", "µ", "ß", "∂", "ø", "∞", "ﬁ", "ϕ", "∏"]
  
  init(scene: SKScene, color: UIColor = .white) {
    self.scene = scene
    self.color = color
  }
  
  func getRandomSymbol() -> String {
    return self.symbols[Int.random(in: 0..<symbols.count)]
  }
  
  func generateAnimatedSymbol(at pos: CGPoint) {
    let symbol = SKLabelNode()
    symbol.text = getRandomSymbol()
    symbol.fontColor = self.color
    symbol.position = pos
    
    self.scene.addChild(symbol)
    
    let symbolAnimation: SKAction = .sequence([
      .group([
        .move(
          by: CGVector(dx: Int.random(in: -70...70), dy: Int.random(in: -70...70)),
          duration: 0.3
        ),
        .fadeOut(withDuration: 0.6)
      ]),
      .run {
        symbol.removeFromParent()
      }
    ])
    
    symbol.run(symbolAnimation)
  }
}
