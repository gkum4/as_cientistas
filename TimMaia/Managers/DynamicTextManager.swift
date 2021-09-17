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
    "i": 16, "j": 20, "k": 16, "l": 12, "m": 26, "n": 21, "o": 22, "p": 21,
    "q": 21, "r": 18, "s": 18, "t": 16, "u": 20, "v": 20, "w": 24, "x": 20,
    "y": 22, "z": 20,
    
    " ": 20, ",": 0, "?": 22, "\'": 12, "(": 12, ")": 12,
    
    "ã": 22, "á": 22, "â": 22, "ç": 22, "ê": 19, "é": 19, "í": 16,
    "ó": 22, "õ": 22, "ô": 22
  ]
  
  let text: String?
  let textWidth: CGFloat?
  let lineHeight: CGFloat?
  let startPos: CGPoint?
  let spacing: CGFloat?
  let textRotation: CGFloat?
  let fontStyle: BasicFontStyle?
  
  var lettersNodes = [SKLabelNode]()
  var textSize = 0
  
  init(
    text: String,
    startPos: CGPoint,
    textWidth: CGFloat,
    lineHeight: CGFloat = 40,
    spacing: CGFloat = 0,
    textRotation: CGFloat = 0,
    fontStyle: BasicFontStyle = BasicFontStyle()
  ) {
    self.text = text
    self.startPos = startPos
    self.textWidth = textWidth
    self.lineHeight = lineHeight
    self.spacing = spacing
    self.textRotation = textRotation
    self.fontStyle = fontStyle
    
    buildText()
  }
  
  private func checkIfWordFitsInLine(textString: String, availableWidth: CGFloat) -> Bool {
    var totalWordWidth: CGFloat = 0
    
    for char in textString {
      if char == " " {
        break
      }
      
      let defaultSpace = defaultLetterSpacing[String(char).lowercased()]
      
      if defaultSpace != nil {
        totalWordWidth += defaultSpace! + spacing!
        continue
      }
      
      totalWordWidth += spacing!
    }
    
    if totalWordWidth > availableWidth {
      return false
    }
    
    return true
  }
  
  private func buildText() {
    var xDisp: CGFloat = 0
    var yDisp: CGFloat = 0
    
    for (i, letter) in text!.enumerated() {
      let node = SKLabelNode(text: String(letter))
      node.zPosition = 1
      node.alpha = 0
      node.zRotation = textRotation!
      node.horizontalAlignmentMode = .center
      node.fontColor = .black
      node.position = CGPoint(x: startPos!.x + xDisp + spacing!, y: startPos!.y + yDisp)
      node.fontColor = fontStyle?.color
      node.fontName = fontStyle?.fontName
      node.fontSize = fontStyle!.fontSize
      
      let defaultSpace = defaultLetterSpacing[String(letter).lowercased()]
      if defaultSpace != nil {
        xDisp += defaultSpace! + spacing!
      }
      else {
        xDisp += spacing!
      }
      
      let index = text!.index(text!.startIndex, offsetBy: i+1)
      
      let nextWordFitInLine = checkIfWordFitsInLine(
        textString: String(text![index...]),
        availableWidth: textWidth! - xDisp
      )
      
      if textWidth! < xDisp || !nextWordFitInLine {
        xDisp = 0
        yDisp -= lineHeight!
      }
      
      lettersNodes.append(node)
    }
    
    textSize = text!.count
  }
}

struct BasicFontStyle {
  var fontName: String = "HelveticaNeue-UltraLight"
  var fontSize: CGFloat = 32.0
  var color: UIColor = .black
}
