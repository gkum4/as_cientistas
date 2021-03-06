//
//  ChemistryInstituteScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 13/09/21.
//

import SpriteKit

class ChemistryInstituteScene: SKScene {
  private var sceneAnimation: SKSpriteNode!
  private var sceneFrames: [SKTexture] = []
  
  private lazy var instituteName: SKLabelNode = { [unowned self] in
    return childNode(withName : "InstituteName") as! SKLabelNode
  }()
  
  private lazy var instituteNameArea: SKSpriteNode = { [unowned self] in
    return childNode(withName : "InstituteNameArea") as! SKSpriteNode
  }()
  
  static func create() -> SKScene {
    let scene = ChemistryInstituteScene(fileNamed: "ChemistryInstituteScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    buildSceneAnimation()
    animateScene()
    buildText()
  }
  
  private func buildText() {
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
    instituteName.removeFromParent()
    sceneAnimation.addChild(instituteName)
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
    let animationSequence: [SKAction] = [
      .animate(
        with: sceneFrames,
        timePerFrame: 0.4,
        resize: false,
        restore: true
      ),
      .wait(forDuration: 0.5),
      .group([
        .move(by: CGVector(dx: 0, dy: 400), duration: 1),
        .scale(by: 1.5, duration: 1)
      ]),
      .run {
        SceneTransition.executeDefaultTransition(
          from: self,
          to: LaboratoryScene.create(),
          nextSceneScaleMode: .aspectFill,
          transition: SKTransition.fade(withDuration: 2)
        )
      }
    ]
    
    sceneAnimation.run(.sequence(animationSequence))
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
