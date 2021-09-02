//
//  DegreeSceneCoreHapticsManager.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 02/09/21.
//

import UIKit
import CoreHaptics

protocol DegreeSceneCoreHapticsManager {
  func playMovePattern()
}

class DefaultDegreeSceneCoreHapticsManager: CoreHapticsManager, DegreeSceneCoreHapticsManager {
  func playMovePattern() {
    do {
      let pattern = try movePattern()
      try playHapticFromPattern(pattern)
    } catch {
      print("Failed to play move pattern: \(error)")
    }
  }
}

extension DefaultDegreeSceneCoreHapticsManager {
  private func movePattern() throws -> CHHapticPattern {
    let move = CHHapticEvent(
      eventType: .hapticContinuous,
      parameters: [
        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.2),
        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1)
      ],
      relativeTime: 0,
      duration: 0.15)

    return try CHHapticPattern(events: [move], parameters: [])
  }
}

