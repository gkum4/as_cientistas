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
  
  private var liseCharNodes: [SKLabelNode] = []
  private var problemCharNodes: [SKLabelNode] = []
  
  static func create() -> SKScene {
    let scene = LisePlayingScene(fileNamed: "LisePlayingScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
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
    let textManager = DynamicTextManager(
      text: "One day I'll be a scientist!",
      startPos: CGPoint(x: -310, y: 420),
      textWidth: 250,
      fontStyle: .init(
        fontName: "NewYorkSmall-Bold",
        fontSize: 38,
        color: .black
      )
    )
    
    self.run(.sequence([
      .wait(forDuration: 1),
      .run {
        for charNode in textManager.lettersNodes {
          charNode.run(.fadeIn(withDuration: 0.2))
          self.liseCharNodes.append(charNode)
          self.addChild(charNode)
        }
      },
      .wait(forDuration: 3.2),
      .run {
        self.eraseText(textNodes: self.liseCharNodes)
      }
    ]))
  }
  
  private func showProblemText() {
    let textManager = DynamicTextManager(
      text: "Women cannot be scientists!",
      startPos: CGPoint(x: -340, y: 443),
      textWidth: 300,
      fontStyle: .init(
        fontName: "NewYorkSmall-Bold",
        fontSize: 38,
        color: .red
      )
    )
    
    self.run(.sequence([
      .wait(forDuration: 5.6),
      .run {
        for charNode in textManager.lettersNodes {
          charNode.run(.fadeIn(withDuration: 0.2))
          self.problemCharNodes.append(charNode)
          self.addChild(charNode)
        }
      }
    ]))
  }
  
  private func animateScene() {
    sceneAnimation.run(.animate(
      with: sceneFrames,
      timePerFrame: 0.2,
      resize: false,
      restore: false
    ))
    
    showLiseText()
    showProblemText()
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
