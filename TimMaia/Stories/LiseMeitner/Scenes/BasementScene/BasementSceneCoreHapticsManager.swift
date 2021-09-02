//
//  BasementSceneCoreHapticsManager.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 01/09/21.
//

import UIKit
import CoreHaptics


protocol BasementSceneCoreHapticsManager {
  func playSpreadPattern()
  func playClickPattern()
}

class DefaultBasementSceneCoreHapticsManager: CoreHapticsManager, BasementSceneCoreHapticsManager {
  func playSpreadPattern() {
    do {
      let pattern = try spreadPattern()
      try playHapticFromPattern(pattern)
    } catch {
      print("Failed to play slice: \(error)")
    }
  }
  
  func playClickPattern() {
    do {
      let pattern = try clickPattern()
      try playHapticFromPattern(pattern)
    } catch {
      print("Failed to play slice: \(error)")
    }
  }
}

extension DefaultBasementSceneCoreHapticsManager {
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
  
  private func clickPattern() throws -> CHHapticPattern {
    let click = CHHapticEvent(
      eventType: .hapticContinuous,
      parameters: [
        CHHapticEventParameter(parameterID: .hapticIntensity, value: 1),
        CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
      ],
      relativeTime: 0,
      duration: 0.01)

    return try CHHapticPattern(events: [click], parameters: [])
  }
}
