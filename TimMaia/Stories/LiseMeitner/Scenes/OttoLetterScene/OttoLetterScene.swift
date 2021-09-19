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
    text: NSLocalizedString("LiseOttoLetterScene", comment: "Comment"),
    startPos: CGPoint(x: -200, y: 470), textWidth: 400,
    fontStyle: BasicFontStyle(fontName: "NewYorkSmall-Regular", fontSize: 30, color: .black))

  
  private var textSize: Int?
  private var textNodes = [SKLabelNode]()
  
  private var gameEnded = false
  
  private var nextButton: SKSpriteNode!
  
  private var tooltipManager: TooltipManager!
  private var symbolsManager: SymbolsManager!
  
  static func create() -> SKScene {
    let scene = OttoLetterScene(fileNamed: "OttoLetterScene")

    return scene!
  }
  
  override func didMove(to view: SKView) {
    self.backgroundColor = .systemBackground
    
    nextButton = (self.childNode(withName: "button") as! SKSpriteNode)
    nextButton.alpha = 0

    textSize = text.textSize
    textNodes = text.lettersNodes
    for node in textNodes {
      addChild(node)
    }
    
    symbolsManager = SymbolsManager(scene: self, color: .black)
    
    tooltipManager = TooltipManager(
      scene: self,
      startPosition: CGPoint(x: -200, y: 470),
      timeBetweenAnimations: 5,
      animationType: .slideToRight
    )
    tooltipManager.startAnimation()
    
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
  
  private func checkAllNodesAppeared() {
    var count = 0
    
    for charNode in textNodes {
      if charNode.alpha != 0 {
        count += 1
      }
    }
    
    if count >= textSize!/2 {
      gameEnded = true
      tooltipManager.stopAnimation()
      showAllCharsAnimation()
      
      nextButton.run(.fadeIn(withDuration: 1.5))
    }
  }
  
  private func showAllCharsAnimation() {
    for charNode in textNodes {
      if charNode.alpha != 1 {
        charNode.run(.fadeIn(withDuration: 1.5))
      }
    }
  }
  
  func touchDown(atPoint pos : CGPoint) {
    if gameEnded && nextButton.contains(pos) {
      SceneTransition.executeDefaultTransition(
        from: self,
        to: NewsScene.create(),
        nextSceneScaleMode: .aspectFill,
        transition: SKTransition.push(with: .left, duration: 2)
      )
      return
    }
    tooltipManager.stopAnimation()
  }
  
  func touchMoved(toPoint pos : CGPoint) {
    symbolsManager.generateAnimatedSymbol(at: pos)
    
    if gameEnded {
      return
    }
    
    for i in 1..<textSize!-1 {
      if textNodes[i].contains(pos) {
        textNodes[i - 1].run(SKAction.fadeIn(withDuration: 0.7))
        textNodes[i].run(SKAction.fadeIn(withDuration: 0.7))
        textNodes[i + 1].run(SKAction.fadeIn(withDuration: 0.7))
        break
      }
    }
    
    checkAllNodesAppeared()
  }
  
  func touchUp(atPoint pos : CGPoint) {
    if gameEnded {
      return
    }
    
    tooltipManager.startAnimation()
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
