//
//  PeriodicTableScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 25/08/21.
//

import SpriteKit

class PeriodicTableScene: SKScene {
  private lazy var periodicTable: SKSpriteNode = { [unowned self] in
    return childNode(withName : "periodicTable") as! SKSpriteNode
  }()
  private lazy var periodicElement: SKSpriteNode = { [unowned self] in
    return childNode(withName : "periodicElement") as! SKSpriteNode
  }()
  private lazy var elementOnTable: SKNode = { [unowned self] in
    return self.periodicTable.children.first as! SKSpriteNode
  }()
  
  private var initialElemPos: CGPoint?
  private var initialElemSize: CGSize?
  private var nodeTouched: SKSpriteNode?
  
  override func didMove(to view: SKView) {
    self.backgroundColor = .systemBackground
    initialElemPos = periodicElement.position
    initialElemSize = periodicElement.size
  }
  
  func touchDown(atPoint pos : CGPoint) {
    nodeTouched = self.atPoint(pos) as? SKSpriteNode
    if nodeTouched == periodicElement {
      periodicElement.scale(to: CGSize(width: periodicElement.size.width * 1.3,
                                       height: periodicElement.size.height * 1.3))
    }
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    if nodeTouched == periodicTable { // Table is only moved on x-axis
      periodicTable.position.x = pos.x
    }
    else {
      periodicElement.position = pos
    }
  }
  
  func touchUp(atPoint pos : CGPoint) {
    if nodeTouched == periodicElement {
      let convertedCoord = convert(periodicElement.position, to: periodicTable)
      if elementOnTable.contains(convertedCoord) {
        elementOnTable.alpha = 1
        periodicElement.alpha = 0
      }
      else { // Moves to initial position on wrong placement
        guard let position = initialElemPos else {
          return
        }
        
        guard let size = initialElemSize else {
          return
        }
        
        let movement = SKAction.move(to: position, duration: 0.6)
        let rescale = SKAction.scale(to: size, duration: 0.6)
        let group = SKAction.group([movement, rescale])
        periodicElement.run(group)
      }
    }
    
    nodeTouched = nil
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
