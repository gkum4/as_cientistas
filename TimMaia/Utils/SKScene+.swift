//
//  SKScene+.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 18/09/21.
//

import SpriteKit
import UIKit

extension SKScene {
  @objc func shake() {
  }
  
  var parentViewController: UIViewController? {
    return self.view?.parentViewController
  }
}
