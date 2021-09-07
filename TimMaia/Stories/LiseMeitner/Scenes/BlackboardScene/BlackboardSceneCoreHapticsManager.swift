//
//  BlackboardSceneCoreHapticsManager.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 02/09/21.
//

import UIKit
import CoreHaptics

protocol BlackboardSceneCoreHapticsManager {
  func playSpreadPattern()
  func playRumblePattern()
}

class DefaultBlackboardSceneCoreHapticsManager: CoreHapticsManager, BlackboardSceneCoreHapticsManager {
  func playSpreadPattern() {
    do {
      let pattern = try spreadPattern()
      try playHapticFromPattern(pattern)
    } catch {
      print("Failed to play slice: \(error)")
    }
  }
  
  func playRumblePattern() {
    playHapticsFile(named: "Rumble")
  }
}

extension DefaultBlackboardSceneCoreHapticsManager {
  private func spreadPattern() throws -> CHHapticPattern {
    let spread = CHHapticEvent(
      eventType: .hapticContinuous,
      parameters: [
        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4),
        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1)
      ],
      relativeTime: 0,
      duration: 0.15)

    return try CHHapticPattern(events: [spread], parameters: [])
  }
}
