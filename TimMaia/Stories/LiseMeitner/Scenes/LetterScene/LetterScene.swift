//
//  LetterScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 07/09/21.
//

import SpriteKit

class LetterScene: SKScene {
  private var letter = SKSpriteNode()
  private var letterFrames: [SKTexture] = []
  
  static func create() -> SKScene {
    let scene = LetterScene(fileNamed: "LetterScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    self.backgroundColor = .systemBackground
    
    buildLetterAnimation()
    animateLetter()
  }
  
  private func buildLetterAnimation() {
    let letterAtlas = SKTextureAtlas(named: "LetterScene")
    var frames: [SKTexture] = []
    
    let numImages = letterAtlas.textureNames.count
    for i in 0..<numImages {
      let letterTextureName = "Letter-\(i)"
      frames.append(letterAtlas.textureNamed(letterTextureName))
    }
    letterFrames = frames
    
    let firstFrameTexture = letterFrames.first
    letter = SKSpriteNode(texture: firstFrameTexture)
    letter.size = CGSize(width: scene!.frame.width, height: scene!.frame.height)
    letter.position = CGPoint(x: frame.midX, y: frame.midY)
    addChild(letter)
  }
  
  private func animateLetter() {
    letter.run(SKAction.animate(with: letterFrames,
                                 timePerFrame: 0.2,
                                 resize: false,
                                 restore: false),
                withKey: "letterAnimation")
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
