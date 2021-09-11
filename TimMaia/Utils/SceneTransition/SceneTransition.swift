//
//  SceneTransition.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 11/09/21.
//

import SpriteKit

class SceneTransition {
  static func executeDefaultTransition(
    from actualScene: SKScene,
    to nextScene: SKScene,
    nextSceneScaleMode: SKSceneScaleMode,
    transition: SKTransition
  ) {
    nextScene.scaleMode = nextSceneScaleMode
    actualScene.view?.presentScene(nextScene, transition: transition)
  }
  
  // custom transitions
  static func executeCustom() {}
}
