//
//  TooltipManager.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 13/09/21.
//

import SpriteKit

class TooltipManager {
  var scene: SKScene
  var startPosition: CGPoint
  var timeInterval: TimeInterval
  var animationType: TooltipAnimationType
  var customAction: SKAction?
  var timer: Timer!
  var text: String
  var textStyle: BasicFontStyle
  
  var hideTooltip: () -> Void = { () }
  
  init(
    scene: SKScene,
    startPosition: CGPoint,
    timeBetweenAnimations: TimeInterval,
    animationType: TooltipAnimationType,
    text: String = "",
    textStyle: BasicFontStyle = BasicFontStyle()
  ) {
    self.scene = scene
    
    self.startPosition = startPosition
    
    self.timeInterval = timeBetweenAnimations
    
    self.animationType = animationType
    
    self.text = text
    
    self.textStyle = textStyle
  }
  
  func getTooltipStyle() -> SKShapeNode {
    let tooltipStyle = SKShapeNode(circleOfRadius: 30)
    tooltipStyle.fillColor = .black
    tooltipStyle.strokeColor = .clear
    tooltipStyle.alpha = 0
    tooltipStyle.zPosition = 1000
    
    return tooltipStyle
  }
  
  func buildCustomAction(positions: [CGPoint], timeBetweenPositions: TimeInterval) {
    var animationSequence: [SKAction] = [.fadeAlpha(to: 0.5, duration: 0.5)]
    
    for i in 0..<positions.count {
      animationSequence.append(.move(to: positions[i], duration: timeBetweenPositions))
    }
    
    animationSequence.append(.fadeOut(withDuration: timeBetweenPositions))
    
    customAction = .sequence(animationSequence)
  }
  
  private func touchAnimation() {
    let tooltip = getTooltipStyle()
    
    tooltip.position = startPosition
    
    self.hideTooltip = {
      tooltip.alpha = 0
    }
    
    scene.addChild(tooltip)
    
    tooltip.run(.sequence([
      .fadeAlpha(to: 0.5, duration: 0.5),
      .scale(by: 0.8, duration: 0.5),
      .scale(by: 1.2, duration: 0.5),
      .fadeOut(withDuration: 0.5),
      .run {
        tooltip.removeFromParent()
      }
    ]))
  }
  
  private func pinchInAnimation() {
    let tooltip1 = getTooltipStyle()
    let tooltip2 = getTooltipStyle()
    
    tooltip1.position = CGPoint(x: startPosition.x, y: startPosition.y+30)
    tooltip2.position = CGPoint(x: startPosition.x, y: startPosition.y-30)
    
    self.hideTooltip = {
      tooltip1.alpha = 0
      tooltip2.alpha = 0
    }
    
    scene.addChild(tooltip1)
    scene.addChild(tooltip2)
    
    tooltip1.run(.sequence([
      .fadeAlpha(to: 0.5, duration: 0.5),
      .move(to: CGPoint(x: tooltip1.position.x, y: tooltip1.position.y+100), duration: 1),
      .fadeOut(withDuration: 0.5),
      .run {
        tooltip1.removeFromParent()
      }
    ]))
    tooltip2.run(.sequence([
      .fadeAlpha(to: 0.5, duration: 0.5),
      .move(to: CGPoint(x: tooltip2.position.x, y: tooltip2.position.y-100), duration: 1),
      .fadeOut(withDuration: 0.5),
      .run {
        tooltip2.removeFromParent()
      }
    ]))
  }
  
  private func pinchOutAnimation() {
    let tooltip1 = getTooltipStyle()
    let tooltip2 = getTooltipStyle()
    
    tooltip1.position = CGPoint(x: startPosition.x, y: startPosition.y+100)
    tooltip2.position = CGPoint(x: startPosition.x, y: startPosition.y-100)
    
    self.hideTooltip = {
      tooltip1.alpha = 0
      tooltip2.alpha = 0
    }
    
    scene.addChild(tooltip1)
    scene.addChild(tooltip2)
    
    tooltip1.run(.sequence([
      .fadeAlpha(to: 0.5, duration: 0.5),
      .move(to: CGPoint(x: tooltip1.position.x, y: tooltip1.position.y-65), duration: 1),
      .fadeOut(withDuration: 0.5),
      .run {
        tooltip1.removeFromParent()
      }
    ]))
    tooltip2.run(.sequence([
      .fadeAlpha(to: 0.5, duration: 0.5),
      .move(to: CGPoint(x: tooltip2.position.x, y: tooltip2.position.y+65), duration: 1),
      .fadeOut(withDuration: 0.5),
      .run {
        tooltip2.removeFromParent()
      }
    ]))
  }
  
  private func slideToBottomAnimation() {
    let tooltip = getTooltipStyle()
    
    tooltip.position = startPosition
    
    self.hideTooltip = {
      tooltip.alpha = 0
    }
    
    scene.addChild(tooltip)
    
    tooltip.run(.sequence([
      .fadeAlpha(to: 0.5, duration: 0.5),
      .move(to: CGPoint(x: tooltip.position.x, y: tooltip.position.y-100), duration: 1),
      .fadeOut(withDuration: 0.5),
      .run {
        tooltip.removeFromParent()
      }
    ]))
  }
  
  private func slideToTopAnimation() {
    let tooltip = getTooltipStyle()
    
    tooltip.position = startPosition
    
    self.hideTooltip = {
      tooltip.alpha = 0
    }
    
    scene.addChild(tooltip)
    
    tooltip.run(.sequence([
      .fadeAlpha(to: 0.5, duration: 0.5),
      .move(to: CGPoint(x: tooltip.position.x, y: tooltip.position.y+100), duration: 1),
      .fadeOut(withDuration: 0.5),
      .run {
        tooltip.removeFromParent()
      }
    ]))
  }
  
  private func slideToRightAnimation() {
    let tooltip = getTooltipStyle()
    
    tooltip.position = startPosition
    
    self.hideTooltip = {
      tooltip.alpha = 0
    }
    
    scene.addChild(tooltip)
    
    tooltip.run(.sequence([
      .fadeAlpha(to: 0.5, duration: 0.5),
      .move(to: CGPoint(x: tooltip.position.x+100, y: tooltip.position.y), duration: 1),
      .fadeOut(withDuration: 0.5),
      .run {
        tooltip.removeFromParent()
      }
    ]))
  }
  
  private func slideToLeftAnimation() {
    let tooltip = getTooltipStyle()
    
    tooltip.position = startPosition
    
    self.hideTooltip = {
      tooltip.alpha = 0
    }
    
    scene.addChild(tooltip)
    
    tooltip.run(.sequence([
      .fadeAlpha(to: 0.5, duration: 0.5),
      .move(to: CGPoint(x: tooltip.position.x-100, y: tooltip.position.y), duration: 1),
      .fadeOut(withDuration: 0.5),
      .run {
        tooltip.removeFromParent()
      }
    ]))
  }
  
  private func textAnimation() {
    let label = SKLabelNode()
    label.text = text
    label.alpha = 0
    label.position = startPosition
    label.fontColor = textStyle.color
    label.fontName = textStyle.fontName
    label.fontSize = textStyle.fontSize
    
    self.hideTooltip = {
      label.alpha = 0
    }
    
    scene.addChild(label)
    
    label.run(.sequence([
      .fadeAlpha(to: 0.5, duration: 0.5),
      .wait(forDuration: 1),
      .fadeOut(withDuration: 0.5),
      .run {
        label.removeFromParent()
      }
    ]))
  }
  
  private func customAnimation() {
    let tooltip = getTooltipStyle()
    
    tooltip.position = startPosition
    
    self.hideTooltip = {
      tooltip.alpha = 0
    }
    
    scene.addChild(tooltip)
    
    tooltip.run(customAction!)
  }
  
  @objc private func runAnimation() {
    switch animationType {
    case .touch:
      touchAnimation()
      
    case .pinchIn:
      pinchInAnimation()
      
    case .pinchOut:
      pinchOutAnimation()
      
    case .slideToBottom:
      slideToBottomAnimation()
      
    case .slideToTop:
      slideToTopAnimation()
      
    case .slideToRight:
      slideToRightAnimation()
      
    case .slideToLeft:
      slideToLeftAnimation()
      
    case .text:
      textAnimation()
      
    case .custom:
      if customAction == nil {
        print("no custom action set")
        return
      }
      customAnimation()
    }
  }
  
  func startAnimation() {
    timer = Timer.scheduledTimer(
      timeInterval: timeInterval,
      target: self,
      selector: #selector(self.runAnimation),
      userInfo: nil,
      repeats: true
    )
  }
  
  func stopAnimation() {
    hideTooltip()
    timer != nil ? timer.invalidate() : nil
  }
}

enum TooltipAnimationType {
  case touch
  case pinchIn
  case pinchOut
  case slideToBottom
  case slideToTop
  case slideToRight
  case slideToLeft
  case text
  case custom
}
