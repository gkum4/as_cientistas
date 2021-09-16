//
//  SwedishUniversityScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 16/09/21.
//

import SpriteKit

class SwedishUniversityScene: SKScene {
  private var sceneAnimation = SKSpriteNode()
  private var sceneFrames: [SKTexture] = []
  
  private lazy var universityName: SKLabelNode = { [unowned self] in
    return childNode(withName : "UniversityName") as! SKLabelNode
  }()
  
  static func create() -> SKScene {
    let scene = SwedishUniversityScene(fileNamed: "SwedishUniversityScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    universityName.text = "University of \n Sweden"
    
    buildSceneAnimation()
    animateScene()
  }
  
  private func buildSceneAnimation() {
    let sceneAtlas = SKTextureAtlas(named: "SwedishUniversityScene")
    var frames: [SKTexture] = []
    
    let numImages = sceneAtlas.textureNames.count
    for i in 0..<numImages {
      let textureName = "UniversityScene-\(i)"
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
                                 timePerFrame: 0.4,
                                 resize: false,
                                 restore: false),
                withKey: "universityAnimation")
  }
  
  func touchDown(atPoint pos : CGPoint) {
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

