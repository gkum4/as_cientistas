//
//  OttoLetterScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 07/09/21.
//

import SpriteKit

class OttoLetterScene: SKScene {
  private var letter = SKSpriteNode()
  private var letterFrames: [SKTexture] = []
  private var text = DynamicTextManager(
    text: "Hello Otto! Here's an update on the progress of our research. I found that the splitting of the Uranium atom releases energy and neutrons, creating a series of nuclear fissions with continuous release of energy and this I have deemed a nuclear fission.",
    startPos: CGPoint(x: -200, y: 470), textWidth: 400,
    fontStyle: BasicFontStyle(fontName: "NewYorkSmall-Regular", fontSize: 30, color: .black))

  
  private var textSize: Int?
  private var textNodes = [SKLabelNode]()
  
  static func create() -> SKScene {
    let scene = OttoLetterScene(fileNamed: "OttoLetterScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    self.backgroundColor = .systemBackground

    textSize = text.textSize
    textNodes = text.lettersNodes
    for node in textNodes {
      addChild(node)
    }
    
    buildLetterAnimation()
    animateLetter()
  }
  
  private func buildLetterAnimation() {
    let letterAtlas = SKTextureAtlas(named: "OttoLetterScene")
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
    for i in 1..<textSize!-1 {
      if textNodes[i].contains(pos) {
        textNodes[i - 1].run(SKAction.fadeIn(withDuration: 1))
        textNodes[i].run(SKAction.fadeIn(withDuration: 1))
        textNodes[i + 1].run(SKAction.fadeIn(withDuration: 1))
      }
    }
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
