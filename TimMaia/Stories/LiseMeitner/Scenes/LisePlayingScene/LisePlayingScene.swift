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
  
  static func create() -> SKScene {
    let scene = LisePlayingScene(fileNamed: "LisePlayingScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    buildLetterAnimation()
    animateLetter()
  }
  
  private func buildLetterAnimation() {
    let sceneAtlas = SKTextureAtlas(named: "LisePlayingScene")
    var frames: [SKTexture] = []
    
    let numImages = sceneAtlas.textureNames.count
    for i in 0..<numImages {
      let letterTextureName = "PlayingScene-\(i)"
      frames.append(sceneAtlas.textureNamed(letterTextureName))
    }
    sceneFrames = frames
    
    let firstFrameTexture = sceneFrames.first
    sceneAnimation = SKSpriteNode(texture: firstFrameTexture)
    sceneAnimation.size = CGSize(width: scene!.frame.width, height: scene!.frame.height)
    sceneAnimation.position = CGPoint(x: frame.midX, y: frame.midY)
    addChild(sceneAnimation)
  }
  
  private func animateLetter() {
    sceneAnimation.run(SKAction.animate(with: sceneFrames,
                                 timePerFrame: 0.2,
                                 resize: false,
                                 restore: false),
                withKey: "playingAnimation")
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
