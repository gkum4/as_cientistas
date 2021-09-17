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
  
  private var tooltipManager: TooltipManager!
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
    noticeText.fontName = "NewYorkSmall-Regular"
    noticeText.fontColor = .red
    
    (self.childNode(withName: "LaboratorySignText") as! SKLabelNode).fontName = "NewYorkSmall-Medium"
    
    tooltipManager = TooltipManager(
      scene: self,
      startPosition: knobArea.position,
      timeBetweenAnimations: 5,
      animationType: .touch
    )
    tooltipManager.startAnimation()

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
    notice.run(.sequence([
      .fadeAlpha(to: notice.alpha + 0.2, duration: 1),
      .wait(forDuration: 1),
      .run {
        if self.notice.alpha >= 0.6 {
          self.tooltipManager.stopAnimation()
          SceneTransition.executeDefaultTransition(
            from: self,
            to: BasementDoorScene.create(),
            nextSceneScaleMode: .aspectFill,
            transition: SKTransition.push(with: .left, duration: 2)
          )
        }
      }
    ]))
    
    
  }
  
  func touchDown(atPoint pos : CGPoint) {
    tooltipManager.stopAnimation()
  }
  
  func touchMoved(toPoint pos : CGPoint) {
  }
  
  func touchUp(atPoint pos : CGPoint) {
    if knobArea.contains(pos) && self.notice.alpha < 0.6 {
      tooltipManager.startAnimation()
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

