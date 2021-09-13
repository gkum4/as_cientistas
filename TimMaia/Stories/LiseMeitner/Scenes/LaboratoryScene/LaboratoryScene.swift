//
//  LaboratoryScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 12/09/21.
//

import SpriteKit

class LaboratoryScene: SKScene {
  private lazy var notice: SKSpriteNode = { [unowned self] in
    return childNode(withName : "LaboratoryNotice") as! SKSpriteNode
  }()
  private lazy var knobArea: SKSpriteNode = { [unowned self] in
    return childNode(withName : "KnobArea") as! SKSpriteNode
  }()
  private lazy var doorKnob: SKSpriteNode = { [unowned self] in
    return childNode(withName : "DoorKnob") as! SKSpriteNode
  }()
  
  private var knobAnimation = SKSpriteNode()
  private var knobFrames: [SKTexture] = []
  
  
  private var hapticsManager: LaboratorySceneHapticsManager?
  private var totalClicks = 0
  
  
  static func create() -> SKScene {
    let scene = LaboratoryScene(fileNamed: "LaboratoryScene")
    scene?.hapticsManager = DefaultLaboratorySceneHapticsManager()

    return scene!
  }
  
  override func didMove(to view: SKView) {
    let noticeText = notice.children.first as! SKLabelNode
    noticeText.text = "Men \n only"

    buildKnobAnimation()
  }
  
  private func buildKnobAnimation() {
    let sceneAtlas = SKTextureAtlas(named: "LaboratorySceneKnob")
    var frames: [SKTexture] = []
    
    let numImages = sceneAtlas.textureNames.count
    for i in 0..<numImages {
      let textureName = "doorKnob-\(i)"
      frames.append(sceneAtlas.textureNamed(textureName))
    }
    knobFrames = frames
    
    let firstFrameTexture = knobFrames.first
    knobAnimation = SKSpriteNode(texture: firstFrameTexture)
    knobAnimation.size = CGSize(width: doorKnob.frame.width, height: doorKnob.frame.height)
    knobAnimation.position = CGPoint(x: doorKnob.position.x, y: doorKnob.position.y)
    addChild(knobAnimation)
  }
  
  private func animateKnob() {
    totalClicks += 1
    
    knobAnimation.run(SKAction.animate(with: knobFrames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: true),
                withKey: "knobAnimation")
    hapticsManager?.triggerWarning()
    notice.run(.fadeAlpha(to: notice.alpha + 0.1, duration: 1))
    
    if notice.alpha >= 0.6 {
      print("Próxima cena")
    }
  }
  
  func touchDown(atPoint pos : CGPoint) {
  }
  
  func touchMoved(toPoint pos : CGPoint) {
  }
  
  func touchUp(atPoint pos : CGPoint) {
    if knobArea.contains(pos) {
      animateKnob()
    }
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

