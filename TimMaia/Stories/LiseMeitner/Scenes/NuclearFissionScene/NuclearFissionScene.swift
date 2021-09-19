//
//  NuclearFissionScene.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 15/09/21.
//

import SpriteKit

class NuclearFissionScene: SKScene {
  private var sceneAnimation = SKSpriteNode()
  private var sceneFrames: [SKTexture] = []
  private var nuclearFissionAnimationTime: Float!
  
  private lazy var sceneTextView: SKSpriteNode = { [unowned self] in
    return childNode(withName : "sceneTextView") as! SKSpriteNode
  }()
  private lazy var textArea: SKSpriteNode = { [unowned self] in
    return childNode(withName : "textViewArea") as! SKSpriteNode
  }()
  private lazy var atomNode: SKSpriteNode = { [unowned self] in
    return childNode(withName : "AtomNode") as! SKSpriteNode
  }()
  private var sceneText = SKLabelNode()
  
  private var animationRunning = false
  
  private var coreHapticsManager: NuclearFissionSceneCoreHapticsManager?
  private var tooltipManager: TooltipManager!
  
  static func create() -> SKScene {
    let scene = NuclearFissionScene(fileNamed: "NuclearFissionScene")
    scene?.coreHapticsManager = DefaultNuclearFissionSceneCoreHapticsManager()

    return scene!
  }
  
  override func didMove(to view: SKView) {
    tooltipManager = TooltipManager(
      scene: self,
      startPosition: CGPoint(x: 0, y: 0),
      timeBetweenAnimations: 5,
      animationType: .touch
    )
    
    showSceneText()
    tooltipManager.startAnimation()
    
    buildSceneAnimation()
  }
  
  private func showSceneText() {
    atomNode.run(.sequence([.wait(forDuration: 4), .fadeIn(withDuration: 1)]))
    
    // Prepares NSAttributedString
    let text = NSLocalizedString("LiseNuclearFissionScene", comment: "Comment")
    let attrString = NSMutableAttributedString(string: text)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    let range = NSRange(location: 0, length: text.count)
    attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
    attrString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "NewYorkSmall-Semibold", size: 40)!], range: range)
    
    sceneText = sceneTextView.childNode(withName: "sceneText") as! SKLabelNode
    sceneText.attributedText = attrString
    sceneText.preferredMaxLayoutWidth = textArea.frame.width
    sceneText.horizontalAlignmentMode = .center
    
    let fadeIn = SKAction.fadeAlpha(to: 0.85, duration: 1.5)
    let wait = SKAction.wait(forDuration: 2)
    let fadeOut = SKAction.fadeAlpha(to: 0, duration: 1)
    let sequence: [SKAction] = [fadeIn, wait, fadeOut]
    
    sceneTextView.run(.sequence(sequence))
  }
  
  private func buildSceneAnimation() {
    let sceneAtlas = SKTextureAtlas(named: "NuclearFissionScene")
    var frames: [SKTexture] = []
    
    let numImages = sceneAtlas.textureNames.count
    
    nuclearFissionAnimationTime = Float(sceneAtlas.textureNames.count) * 0.2
    
    for i in 0..<numImages {
      let textureName = "NuclearFission-\(i)"
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
    let animation: SKAction = .sequence([
      .animate(
        with: sceneFrames,
         timePerFrame: 0.2,
         resize: false,
         restore: false
      ),
      .run {
        SceneTransition.executeDefaultTransition(
          from: self,
          to: NuclearFissionPaperScene.create(),
          nextSceneScaleMode: .aspectFill,
          transition: .fade(withDuration: 2)
        )
      }
    ])
    
    sceneAnimation.run(animation)
    
    // use nuclearFissionAnimationTime to wait to execute transition
  }
  
  func touchDown(atPoint pos : CGPoint) {
    atomNode.run(.fadeOut(withDuration: 0.3))
    if animationRunning {
      return
    }
    
    animationRunning = true
    tooltipManager.stopAnimation()
    animateScene()
    Timer.scheduledTimer(withTimeInterval: 4.4, repeats: false, block: {_ in
      self.coreHapticsManager?.playExplosionPattern()
    })
    coreHapticsManager?.playRumblePattern()
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
