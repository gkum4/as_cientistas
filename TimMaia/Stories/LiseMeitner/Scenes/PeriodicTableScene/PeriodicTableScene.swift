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
  
  private lazy var sceneTextView: SKSpriteNode = { [unowned self] in
    return childNode(withName : "sceneTextView") as! SKSpriteNode
  }()
  private var sceneText = SKLabelNode()
  
  private var initialElemPos: CGPoint?
  private var tablePosition: CGPoint?
  private var initialElemSize: CGSize?
  private var nodeTouched: SKSpriteNode?
  private var firstTouchPos: CGPoint?
  private var hapticsManager: PeriodicTableSceneHapticsManager?
  private var coreHapticsManager: PeriodicTableSceneCoreHapticsManager?
  
  static func create() -> SKScene {
    let scene = PeriodicTableScene(fileNamed: "PeriodicTableScene")
    scene?.hapticsManager = DefaultPeriodicTableSceneHapticsManager()
    scene?.coreHapticsManager = DefaultPeriodicTableSceneCoreHapticsManager()

    return scene!
  }
  
  override func didMove(to view: SKView) {
    initialElemPos = periodicElement.position
    tablePosition = periodicTable.position
    initialElemSize = periodicElement.size
    
    sceneText = sceneTextView.childNode(withName: "sceneText") as! SKLabelNode
    sceneText.text = "O elemento Mt (Meitnério) \n recebeu esse nome em \n homenagem a Lise Meitner"
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
      if firstTouchPos == nil {
        firstTouchPos = pos
      }
      periodicTable.position.x = tablePosition!.x + (pos.x - firstTouchPos!.x)
    }
    else {
      periodicElement.position = pos
    }
  }
  
  private func showSceneText() {
    let fadeIn = SKAction.fadeAlpha(to: 0.85, duration: 1.5)
    let wait = SKAction.wait(forDuration: 5)
    let fadeOut = SKAction.fadeAlpha(to: 0, duration: 1.5)
    let sequence = SKAction.sequence([fadeIn, wait, fadeOut])
    sceneTextView.run(sequence)
  }
  
  func touchUp(atPoint pos : CGPoint) {
    if nodeTouched == periodicElement {
      let convertedCoord = convert(periodicElement.position, to: periodicTable)
      
      if elementOnTable.contains(convertedCoord) {
        elementOnTable.alpha = 1
        periodicElement.alpha = 0
        hapticsManager?.triggerSuccess()
        
        showSceneText()
      }
      else { // Moves to initial position on wrong placement
        guard let position = initialElemPos else {
          return
        }
        
        guard let size = initialElemSize else {
          return
        }
        
        coreHapticsManager?.playFilePattern()
        let movement = SKAction.move(to: position, duration: 0.6)
        let rescale = SKAction.scale(to: size, duration: 0.6)
        let group = SKAction.group([movement, rescale])
        periodicElement.run(group)
      }
    }
    else {
      tablePosition = periodicTable.position
    }
    
    firstTouchPos = nil
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
