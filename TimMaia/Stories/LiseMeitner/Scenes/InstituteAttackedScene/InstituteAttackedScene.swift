//
//  InstituteAttackedScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 16/09/21.
//

import SpriteKit

class InstituteAttackedScene: SKScene {
  private var sceneAnimation = SKSpriteNode()
  private var sceneFrames: [SKTexture] = []
  
  private lazy var institute: SKSpriteNode = { [unowned self] in
    return childNode(withName : "Institute-0") as! SKSpriteNode
  }()
  private lazy var instituteDestroyed: SKSpriteNode = { [unowned self] in
    return childNode(withName : "Institute-1") as! SKSpriteNode
  }()
  
  private lazy var instituteNameArea: SKSpriteNode = { [unowned self] in
    return childNode(withName : "InstituteNameArea") as! SKSpriteNode
  }()
  private lazy var instituteName: SKLabelNode = { [unowned self] in
    return childNode(withName : "InstituteName") as! SKLabelNode
  }()
  private lazy var tankPosition: SKSpriteNode = { [unowned self] in
    return childNode(withName : "TankFinalPosition") as! SKSpriteNode
  }()
  
  private var tooltipManager: TooltipManager!
  
  private var coreHapticsManager: InstituteAttackedSceneCoreHapitcsManager?
  
  static func create() -> SKScene {
    let scene = InstituteAttackedScene(fileNamed: "InstituteAttackedScene")
    scene?.coreHapticsManager = DefaultInstituteAttackedSceneCoreHapticsManager()

    return scene!
  }
  
  override func didMove(to view: SKView) {
    setupInstituteName()
    buildSceneAnimation()
    animateScene()
    
    tooltipManager = TooltipManager(
      scene: self,
      startPosition: tankPosition.position,
      timeBetweenAnimations: 5,
      animationType: .touch
    )
    tooltipManager.startAnimation()
  }
  
  private func setupInstituteName() {
    // Prepares NSAttributedString
    let text = NSLocalizedString("LiseChemistryIntitute", comment: "Comment")
    let attrString = NSMutableAttributedString(string: text)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    let range = NSRange(location: 0, length: text.count)
    attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
    attrString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "NewYorkSmall-Bold", size: 55)!], range: range)
    
    instituteName.attributedText = attrString
    instituteName.preferredMaxLayoutWidth = instituteNameArea.frame.width
    instituteName.horizontalAlignmentMode = .center
    instituteName.position.y -= 15
  }
  
  private func buildSceneAnimation() {
    let sceneAtlas = SKTextureAtlas(named: "TankAnimation")
    var frames: [SKTexture] = []
    
    let numImages = sceneAtlas.textureNames.count
    for i in 0..<numImages {
      let textureName = "Tank-\(i)"
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
    sceneAnimation.run(.animate(with: sceneFrames,
                                 timePerFrame: 0.3,
                                 resize: false,
                                 restore: false),
                withKey: "tankAnimation")
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if tankPosition.contains(pos) {
      tooltipManager.stopAnimation()
      institute.run(.sequence([
        .run {
          self.institute.alpha = 0
        },
        .wait(forDuration: 2),
        .run {
          SceneTransition.executeDefaultTransition(
            from: self,
            to: CarScene.create(),
            nextSceneScaleMode: .aspectFill,
            transition: SKTransition.push(with: .left, duration: 2)
          )
        }
      ]))
      coreHapticsManager?.playFilePattern()
    }
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
