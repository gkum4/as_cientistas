//
//  LisePlayingScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 12/09/21.
//

import SpriteKit

class LisePlayingScene: SKScene {
  private var sceneAnimation = SKSpriteNode()
  private var sceneFrames: [SKTexture] = []
  
  private var nextButton: SKSpriteNode!
  
  private var animationEnded = false
  
  private var liseCharNodes: [SKLabelNode] = []
  private var problemCharNodes: [SKLabelNode] = []
  
  private lazy var liseBallonArea: SKSpriteNode = { [unowned self] in
    return childNode(withName : "LiseBallonArea") as! SKSpriteNode
  }()
  private lazy var adultBallonArea: SKSpriteNode = { [unowned self] in
    return childNode(withName : "AdultBallonArea") as! SKSpriteNode
  }()
  
  static func create() -> SKScene {
    let scene = LisePlayingScene(fileNamed: "LisePlayingScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    nextButton = (self.childNode(withName: "button") as! SKSpriteNode)
    nextButton.alpha = 0
    
    buildSceneAnimation()
    animateScene()
  }
  
  private func buildSceneAnimation() {
    let sceneAtlas = SKTextureAtlas(named: "LisePlayingScene")
    var frames: [SKTexture] = []
    
    let numImages = sceneAtlas.textureNames.count
    for i in 0..<numImages {
      let textureName = "PlayingScene-\(i)"
      frames.append(sceneAtlas.textureNamed(textureName))
    }
    sceneFrames = frames
    
    let firstFrameTexture = sceneFrames.first
    sceneAnimation = SKSpriteNode(texture: firstFrameTexture)
    sceneAnimation.size = CGSize(width: scene!.frame.width, height: scene!.frame.height)
    sceneAnimation.position = CGPoint(x: frame.midX, y: frame.midY)
    addChild(sceneAnimation)
  }
  
  private func eraseText(textNodes: [SKLabelNode]) {
    for charNode in textNodes {
      charNode.run(.fadeAlpha(to: 0, duration: 0.5))
    }
  }
  
  private func showLiseText() {
    let label = SKLabelNode()
    label.fontName = "NewYorkSmall-Bold"
    label.fontSize = 32
    label.alpha = 0
    label.numberOfLines = 3
    label.fontColor = .black
    label.position = liseBallonArea.position
    label.preferredMaxLayoutWidth = liseBallonArea.frame.width
    label.text = NSLocalizedString("LisePlayingScene1", comment: "Comment")
    
    self.run(.sequence([
      .wait(forDuration: 1),
      .run {
        label.run(.fadeIn(withDuration: 0.2))
        self.addChild(label)
      },
      .wait(forDuration: 3.2),
      .run {
        label.run(.fadeOut(withDuration: 0.2))
      }
    ]))
  }
  
  private func showProblemText() {
    let label = SKLabelNode()
    label.fontName = "NewYorkSmall-Bold"
    label.fontSize = 38
    label.fontColor = .red
    label.text = NSLocalizedString("LisePlayingScene2", comment: "Comment")
    label.position = adultBallonArea.position
    label.numberOfLines = 2
    label.alpha = 0
    label.preferredMaxLayoutWidth = adultBallonArea.frame.width
    
    self.run(.sequence([
      .wait(forDuration: 5.6),
      .run {
        label.run(.fadeIn(withDuration: 0.2))
        self.addChild(label)
      }
    ]))
  }
  
  private func animateScene() {
    sceneAnimation.run(.sequence([
      .animate(
        with: sceneFrames,
        timePerFrame: 0.2,
        resize: false,
        restore: false
      ),
      .run {
        self.animationEnded = true
        self.nextButton.run(.fadeIn(withDuration: 1))
      }
    ]))
    
    showLiseText()
    showProblemText()
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if animationEnded && nextButton.contains(pos) {
      SceneTransition.executeDefaultTransition(
        from: self,
        to: DadScene.create(),
        nextSceneScaleMode: .aspectFill,
        transition: SKTransition.push(with: .left, duration: 2)
      )
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
