//
//  HapticsManager.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 29/08/21.
//

import UIKit

final class HapticsManager {
  static let shared = HapticsManager()
  
  private init() {}
  
  public func vibrateByType(for type: UINotificationFeedbackGenerator.FeedbackType) {
    DispatchQueue.main.async {
      let notificationGenerator = UINotificationFeedbackGenerator()
      notificationGenerator.prepare()
      notificationGenerator.notificationOccurred(type)
    }
  }
  
  public func vibrateByImpact(intensity: CGFloat) {
    DispatchQueue.main.async {
      let impactGenerator = UIImpactFeedbackGenerator()
      impactGenerator.prepare()
      impactGenerator.impactOccurred(intensity: intensity * 100)
    }
  }
}
