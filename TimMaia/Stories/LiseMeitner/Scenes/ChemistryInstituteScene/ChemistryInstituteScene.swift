//
//  ChemistryInstituteScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 13/09/21.
//

import SpriteKit

class ChemistryInstituteScene: SKScene {
  private var sceneAnimation = SKSpriteNode()
  private var sceneFrames: [SKTexture] = []
  
  private lazy var instituteNameView: SKSpriteNode = { [unowned self] in
    return childNode(withName : "InstituteNameView") as! SKSpriteNode
  }()
  private lazy var instituteName: SKLabelNode = { [unowned self] in
    return childNode(withName : "InstituteName") as! SKLabelNode
  }()
  
  static func create() -> SKScene {
    let scene = ChemistryInstituteScene(fileNamed: "ChemistryInstituteScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    setupInstituteName()
    buildSceneAnimation()
    animateScene()
  }
  
  private func setupInstituteName() {
    instituteName.fontSize = 55
    instituteName.fontName = "NewYorkSmall-Bold"
    instituteName.text = "Kaiser Wilhelm Institute"
    
    instituteName.position.x = instituteNameView.position.x
    instituteName.preferredMaxLayoutWidth = instituteNameView.frame.width
  }
  
  private func buildSceneAnimation() {
    let sceneAtlas = SKTextureAtlas(named: "ChemistryInstituteScene")
    var frames: [SKTexture] = []
    
    let numImages = sceneAtlas.textureNames.count
    for i in 0..<numImages {
      let textureName = "InstituteScene-\(i)"
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
                                 restore: true),
                withKey: "instituteAnimation")
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
