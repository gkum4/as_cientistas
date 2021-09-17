//
//  BasementDoorScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 12/09/21.
//

import SpriteKit

class BasementDoorScene: SKScene {
  private lazy var knobArea: SKSpriteNode = { [unowned self] in
    return childNode(withName : "KnobArea") as! SKSpriteNode
  }()
  
  private var sceneAnimation = SKSpriteNode()
  private var sceneFrames: [SKTexture] = []
  private var attempts = 0
  
  private var tooltipManager: TooltipManager!
  private var hapticsManager: BasementDoorSceneHapticsManager?
  
  static func create() -> SKScene {
    let scene = BasementDoorScene(fileNamed: "BasementDoorScene")
    scene?.hapticsManager = DefaultBasementDoorSceneHapticsManager()

    return scene!
  }
  
  override func didMove(to view: SKView) {
    tooltipManager = TooltipManager(
      scene: self,
      startPosition: CGPoint(x: knobArea.position.x+9, y: knobArea.position.y-9),
      timeBetweenAnimations: 5,
      animationType: .touch
    )
    tooltipManager.startAnimation()
    
    buildSceneAnimation()
  }
  
  private func buildSceneAnimation() {
    let sceneAtlas = SKTextureAtlas(named: "BasementDoorScene")
    var frames: [SKTexture] = []
    
    let numImages = sceneAtlas.textureNames.count
    for i in 0..<numImages {
      let textureName = "BasementDoor-\(i)"
      frames.append(sceneAtlas.textureNamed(textureName))
    }
    sceneFrames = frames
    
    let firstFrameTexture = sceneFrames.first
    sceneAnimation = SKSpriteNode(texture: firstFrameTexture)
    sceneAnimation.size = CGSize(width: scene!.frame.width, height: scene!.frame.height)
    sceneAnimation.position = CGPoint(x: frame.midX, y: frame.midY)
    addChild(sceneAnimation)
  }
  
  private func animateScene(onAnimationEnd: @escaping () -> Void) {
    sceneAnimation.run(SKAction.animate(with: sceneFrames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: false),
                withKey: "doorOpeningAnimation")
    
    let wait = SKAction.wait(forDuration: 2)
    let zoomIn = SKAction.scale(to: 1.3, duration: 1)
    let sequence = SKAction.sequence([
      wait,
      zoomIn,
      .run {
        onAnimationEnd()
      }
    ])
    sceneAnimation.run(sequence)
  }
  
  private func checkForDoorOpen(atPoint pos: CGPoint) {
    if knobArea.contains(pos) {
//      attempts += 1
//
//      if attempts >= 3 {
//        animateScene()
//        hapticsManager?.triggerSuccess()
//      }
//      else {
//        hapticsManager?.triggerWarning()
//      }
      
      self.tooltipManager.stopAnimation()
      
      animateScene(onAnimationEnd: {
        
        // scene transition
      })
      hapticsManager?.triggerSuccess()
    }
  }
  
  func touchDown(atPoint pos : CGPoint) {
  }
  
  func touchMoved(toPoint pos : CGPoint) {
  }
  
  func touchUp(atPoint pos : CGPoint) {
    checkForDoorOpen(atPoint: pos)
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

