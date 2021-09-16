//
//  LiseWithBoysSceneHapticsManager.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 13/09/21.
//

import UIKit
import CoreHaptics

protocol LiseWithBoysSceneCoreHapticsManager {
  func playGrabPattern()
}

class DefaultLiseWithBoysSceneCoreHapticsManager: CoreHapticsManager, LiseWithBoysSceneCoreHapticsManager {
  func playGrabPattern() {
    do {
      let pattern = try GrabPattern()
      try playHapticFromPattern(pattern)
    } catch {
      print("Failed to play slice: \(error)")
    }
  }
}

extension DefaultLiseWithBoysSceneCoreHapticsManager {
  private func GrabPattern() throws -> CHHapticPattern {
    let grab = CHHapticEvent(
      eventType: .hapticContinuous,
      parameters: [
        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6),
        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.6)
      ],
      relativeTime: 0,
      duration: 0.15)

    return try CHHapticPattern(events: [grab], parameters: [])
  }
}
