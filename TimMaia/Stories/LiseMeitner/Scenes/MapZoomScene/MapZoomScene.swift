//
//  MapZoomScene.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 31/08/21.
//

import SpriteKit
import GameplayKit

class MapZoomScene: SKScene {
  private var sceneNumber: Int = 0
  
  private var nextMapView: SKSpriteNode?
  private lazy var mapView: SKSpriteNode = { [unowned self] in
    return childNode(withName : "MapScene-\(sceneNumber)") as! SKSpriteNode
  }()
  private lazy var targetLocation: SKSpriteNode = { [unowned self] in
    return childNode(withName : "Locale-\(sceneNumber)") as! SKSpriteNode
  }()
  
  private var equationM: CGFloat?
  private var equationB: CGFloat?
  
  private var didReachCenter: Bool = true
  private var didReachTarget: Bool = false
  private var pinchCount: CGFloat = 1.0
  private var pinchFactor: CGFloat = 1.5
  private var zoomInScale: CGFloat = 0.988
  private var zoomOutScale: CGFloat = 0.006
  private var previousGestureScale: CGFloat = 1.0
  
  private var hapticsManager: MapZoomSceneHapticsManager?

  static func create() -> SKScene {
    let scene = MapZoomScene(fileNamed: "MapZoomScene")
    scene?.hapticsManager = DefaultMapZoomSceneHapticsManager()

    return scene!
  }
  
  override func didMove(to view: SKView) {
    self.backgroundColor = .systemBackground

    let camera = SKCameraNode()
    self.addChild(camera)
    self.camera = camera

    addPinchGesture()
    getLineEquation()
  }
  
  private func addPinchGesture() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
    view?.addGestureRecognizer(pinchGesture)
  }
  
  private func getLineEquation() {
    // Calculates slope
    let y = targetLocation.position.y - mapView.position.y
    let x = targetLocation.position.x - mapView.position.x
    equationM = y / x
    
    // Calculates b and steps
    equationB = targetLocation.position.y - (equationM! * targetLocation.position.x)
    
    // Sets variables to original values
    pinchCount = 1.0
    didReachCenter = true
    didReachTarget = false
  }
  
  private func checkForTarget(pos: CGPoint) {
    if abs(pos.x - targetLocation.position.x) <= 1 {
      didReachTarget = true
    }
  }
  
  private func checkForCenter(pos: CGPoint) {
    if abs(pos.x - mapView.position.x) <= 1 {
      didReachCenter = true
    }
  }
  
  @objc private func didPinch(_ gesture: UIPinchGestureRecognizer) {
    if gesture.state == .changed {
      if(gesture.scale > previousGestureScale && !didReachTarget) {
        zoomInMapView()
      }
      else if (gesture.scale < previousGestureScale && !didReachTarget && !didReachCenter) {
        zoomOutMapView()
      }
      else if (didReachTarget){
        changeMapView()
      }
      
      previousGestureScale = gesture.scale
    }
  }
  
  private func zoomInMapView() {
    var x: CGFloat = 0
    // Moves based on x value
    if targetLocation.position.x > mapView.position.x {
      x = mapView.position.x + pinchCount
    }
    else {
      x = mapView.position.x - pinchCount
    }
    
    let y = (equationM! * x) + equationB!
    pinchCount = pinchCount + pinchFactor
    
    checkForTarget(pos: CGPoint(x: x, y: y))
    didReachCenter = false

    let movement = SKAction.move(to: CGPoint(x: x, y: y), duration: 0)
    let zoomIn = SKAction.scale(by: zoomInScale, duration: 0)
    let group = SKAction.group([movement, zoomIn])
    self.camera?.run(group)
  }
  
  private func zoomOutMapView() {
    let x = pinchCount - pinchFactor
    let y = (equationM! * x) + equationB!
    pinchCount = pinchCount - pinchFactor
    
    checkForCenter(pos: CGPoint(x: x, y: y))
    
    let movement = SKAction.move(to: CGPoint(x: x, y: y), duration: 0)
    let rescaleX = SKAction.scaleX(to: self.camera!.xScale + zoomOutScale, duration: 0)
    let rescaleY = SKAction.scaleY(to: self.camera!.yScale + zoomOutScale, duration: 0)
    let group = SKAction.group([rescaleX, rescaleY, movement])
    self.camera?.run(group)
  }
  
  private func changeMapView() {
    sceneNumber = sceneNumber + 1
    
    if sceneNumber < 3 {
      // Disables pinch untill map view changes
      view?.gestureRecognizers?.first?.isEnabled = false
      
      // Sets up next map view
      nextMapView = SKSpriteNode(imageNamed: "MapScene-\(sceneNumber)")
      nextMapView?.scale(to: CGSize(width: mapView.size.width, height: mapView.size.height))
      nextMapView?.zPosition = 0
      nextMapView?.alpha = 1
      mapView.zPosition = 1
      self.addChild(nextMapView!)
      
      // Transition between maps
      let oldActionsSeq = SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.fadeOut(withDuration: 1)])
      let newActionsSeq = SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.fadeIn(withDuration: 1)])
      mapView.run(oldActionsSeq)
      nextMapView!.run(newActionsSeq)
      mapView = nextMapView!
      
      // Updates target location
      targetLocation = childNode(withName : "Locale-\(sceneNumber)") as! SKSpriteNode
      getLineEquation()

      // Resets camera to original position
      let rescaleX = SKAction.scaleX(to: 1.0, duration: 2)
      let rescaleY = SKAction.scaleY(to: 1.0, duration: 2)
      let movement = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 2)
      let zoomOut = SKAction.group([rescaleX, rescaleY, movement])
      let cameraSeq = SKAction.sequence([SKAction.wait(forDuration: 2), zoomOut])
      self.camera?.run(cameraSeq)
      
      // Reanables pinch movement
      view?.gestureRecognizers?.first?.isEnabled = true
    }
    else {
      print("Próxima cena")
    }
  }
  
  func touchDown(atPoint pos : CGPoint) {
//    if targetLocation.contains(pos) && didReachPoint! {
//      hapticsManager?.triggerSuccess()
//      changeMapView()
//    }
  }
  
  func touchMoved(toPoint pos : CGPoint) {
  }
  
  func touchUp(atPoint pos : CGPoint) {
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      for t in touches { self.touchDown(atPoint: t.location(in: self)) }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
  
  
  override func update(_ currentTime: TimeInterval) {
      // Called before each frame is rendered
  }
}

