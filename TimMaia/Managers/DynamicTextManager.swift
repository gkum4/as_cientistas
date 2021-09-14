//
//  TextProcessing.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 10/09/21.
//

import SpriteKit

class DynamicTextManager {
  let defaultLetterSpacing: [String: CGFloat] = [
    "a": 22, "b": 22, "c": 22, "d": 24, "e": 19, "f": 17, "g": 24, "h": 17,
    "i": 14, "j": 20, "k": 16, "l": 12, "m": 26, "n": 21, "o": 22, "p": 21,
    "q": 21, "r": 18, "s": 18, "t": 16, "u": 20, "v": 20, "w": 24, "x": 20,
    "y": 22, "z": 20, " ": 20, ",": 0
  ]
  
  let text: String?
  let textWidth: CGFloat?
  let lineHeight: CGFloat?
  let startPos: CGPoint?
  let spacing: CGFloat?
  let textRotation: CGFloat?
  
  var lettersNodes = [SKLabelNode]()
  var textSize = 0
  
  init(text: String, startPos: CGPoint, textWidth: CGFloat, lineHeight: CGFloat = 40,
       spacing: CGFloat = 0, textRotation: CGFloat = 0) {
    self.text = text
    self.startPos = startPos
    self.textWidth = textWidth
    self.lineHeight = lineHeight
    self.spacing = spacing
    self.textRotation = textRotation
    
    buildText()
  }
  
  private func buildText() {
    var xDisp: CGFloat = 0
    var yDisp: CGFloat = 0
    
    for letter in text! {
      let node = SKLabelNode(text: String(letter))
      node.zPosition = 1
      node.alpha = 0
      node.zRotation = textRotation!
      node.horizontalAlignmentMode = .center
      node.fontColor = .black
      node.position = CGPoint(x: startPos!.x + xDisp + spacing!, y: startPos!.y + yDisp)
      
      
      let defaultSpace = defaultLetterSpacing[String(letter).lowercased()]
      if defaultSpace != nil {
        xDisp += defaultSpace! + spacing!
      }
      else {
        xDisp += spacing!
      }
      
      if textWidth! < xDisp {
        xDisp = 0
        yDisp -= lineHeight!
      }
      
      lettersNodes.append(node)
    }
    
    textSize = text!.count
  }
}
