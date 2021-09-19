//
//  SKView+.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 02/09/21.
//

import SpriteKit

extension SKView {
  open override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if let scene = self.scene {
      scene.shake()
    }
  }
}
