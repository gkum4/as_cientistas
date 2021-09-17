//
//  NuclearFissionPaperSceneCoreHapticsManager.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 15/09/21.
//

import UIKit
import CoreHaptics

protocol NuclearFissionPaperSceneCoreHapticsManager {
  func playClickPattern()
}

class DefaultNuclearFissionPaperSceneCoreHapticsManager: CoreHapticsManager, NuclearFissionPaperSceneCoreHapticsManager {
  func playClickPattern() {
    do {
      let pattern = try clickPattern()
      try playHapticFromPattern(pattern)
    } catch {
      print("Failed to play slice: \(error)")
    }
  }
}

extension DefaultNuclearFissionPaperSceneCoreHapticsManager {
  private func clickPattern() throws -> CHHapticPattern {
    let click = CHHapticEvent(
      eventType: .hapticContinuous,
      parameters: [
        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
      ],
      relativeTime: 0,
      duration: 0.05)

    return try CHHapticPattern(events: [click], parameters: [])
  }
}
