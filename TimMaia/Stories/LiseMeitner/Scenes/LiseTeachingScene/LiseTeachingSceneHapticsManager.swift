//
//  LiseTeachingSceneHapticsManager.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 13/09/21.
//

import UIKit

protocol LiseTeachingSceneHapticsManager {
  func triggerSuccess()
}

class DefaultLiseTeachingSceneHapticsManager: HapticsManager, LiseTeachingSceneHapticsManager {
  func triggerSuccess() {
    vibrateByType(for: .success)
  }
}

