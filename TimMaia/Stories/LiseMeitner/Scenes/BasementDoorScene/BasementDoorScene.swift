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
  
  private var hapticsManager: BasementDoorSceneHapticsManager?
  
  static func create() -> SKScene {
    let scene = BasementDoorScene(fileNamed: "BasementDoorScene")
    scene?.hapticsManager = DefaultBasementDoorSceneHapticsManager()

    return scene!
  }
  
  override func didMove(to view: SKView) {
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
  
  private func animateScene() {
    sceneAnimation.run(SKAction.animate(with: sceneFrames,
                                 timePerFrame: 0.1,
                                 resize: false,
                                 restore: false),
                withKey: "doorOpeningAnimation")
  }
  
  func touchDown(atPoint pos : CGPoint) {
  }
  
  func touchMoved(toPoint pos : CGPoint) {
  }
  
  func touchUp(atPoint pos : CGPoint) {
    if knobArea.contains(pos) {
      animateScene()
      hapticsManager?.triggerSuccess()
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

