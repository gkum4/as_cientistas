//
//  HapticsManager.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 29/08/21.
//

import UIKit

class HapticsManager {
  let notificationGenerator = UINotificationFeedbackGenerator()
  let impactGenerator = UIImpactFeedbackGenerator()
  
  init() {}
  
  public func vibrateByType(for type: UINotificationFeedbackGenerator.FeedbackType) {
    DispatchQueue.main.async { [weak self] in
      self?.notificationGenerator.prepare()
      self?.notificationGenerator.notificationOccurred(type)
    }
  }
  
  public func vibrateByImpact(intensity: CGFloat) {
    DispatchQueue.main.async { [weak self] in
      self?.impactGenerator.prepare()
      self?.impactGenerator.impactOccurred(intensity: intensity * 100)
    }
  }
}
