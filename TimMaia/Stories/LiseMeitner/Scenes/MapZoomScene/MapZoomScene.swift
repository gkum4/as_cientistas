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
  private var nextTargetLocation: SKSpriteNode?
  private var nextTargetLocationName: SKLabelNode?
  private lazy var mapView: SKSpriteNode = { [unowned self] in
    return childNode(withName : "MapScene-\(sceneNumber)") as! SKSpriteNode
  }()
  private lazy var targetLocation: SKSpriteNode = { [unowned self] in
    return childNode(withName : "Marker-\(sceneNumber)") as! SKSpriteNode
  }()
  
  private lazy var targetLocationName: SKLabelNode = { [unowned self] in
    return childNode(withName : "MarkerText-\(sceneNumber)") as! SKLabelNode
  }()
  
  private var equationM: CGFloat?
  private var equationB: CGFloat?
  private var targetInitialScale: CGFloat?
  
  private var didReachCenter: Bool = true
  private var didReachTarget: Bool = false
  private var isTransitioning: Bool = false
  private var totalScenes: Int = 4
  private var pinchCount: CGFloat = 1.0
  private var pinchFactor: CGFloat = 1.7
  private var zoomInScale: CGFloat = 0.985
  private var zoomOutScale: CGFloat = 0.008
  private var previousGestureScale: CGFloat = 1.0
  
  private var tooltipManager: TooltipManager!
  private var hapticsManager: MapZoomSceneHapticsManager?

  static func create() -> SKScene {
    let scene = MapZoomScene(fileNamed: "MapZoomScene")
    scene?.hapticsManager = DefaultMapZoomSceneHapticsManager()

    return scene!
  }
  
  override func didMove(to view: SKView) {
    BackgroundMusicManager.shared.play(fileName: "Hopeful-Freedom-Asher-Fulero", fileType: "mp3")
    
    self.backgroundColor = .systemBackground

    let camera = SKCameraNode()
    self.addChild(camera)
    self.camera = camera

    setupTarget()
    addPinchGesture()
    getLineEquation()
    
    tooltipManager = TooltipManager(
      scene: self,
      startPosition: CGPoint(x: 0, y: 0),
      timeBetweenAnimations: 5,
      animationType: .pinchIn
    )
    
    tooltipManager.startAnimation()
  }
  
  private func setupTarget() {
    targetInitialScale = targetLocation.xScale
    
    targetLocationName.text = NSLocalizedString("LiseLocationName\(sceneNumber)", comment: "Comment")
    targetLocationName.fontColor = .white
    targetLocationName.fontSize = 15
    targetLocationName.fontName = "NewYorkSmall-MediumItalic"
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
  
  private func configureTooltipForPinchIn() {
    tooltipManager.stopAnimation()
    tooltipManager = TooltipManager(
      scene: self,
      startPosition: CGPoint(x: 0, y: 0),
      timeBetweenAnimations: 5,
      animationType: .pinchIn
    )
  }
  
  private func configureTooltipForTouch(at pos: CGPoint) {
    tooltipManager.stopAnimation()
    tooltipManager = TooltipManager(
      scene: self,
      startPosition: pos,
      timeBetweenAnimations: 5,
      animationType: .touch
    )
  }
  
  private func checkForTarget(pos: CGPoint) {
    if abs(pos.x - targetLocation.position.x) <= 1 {
      didReachTarget = true
      configureTooltipForTouch(at: targetLocation.position)
      tooltipManager.startAnimation()
      print(targetLocation.xScale)
      let scaleUp = SKAction.scale(to: targetInitialScale! * 1.3, duration: 2)
      let scaleDown = SKAction.scale(to: targetInitialScale!, duration: 2)
      let sequence = SKAction.sequence([scaleUp, scaleDown])
      targetLocation.run(SKAction.repeatForever(sequence))
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
        if(!isTransitioning) {
          zoomInMapView()
        }
        else if (camera?.position == CGPoint(x: 0, y: 0)) { // Transition ended
          isTransitioning = false
        }
      }
      else if (gesture.scale < previousGestureScale && !didReachTarget && !didReachCenter) {
        zoomOutMapView()
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
  
  private func rescaleCameraOnViewChange(pos: CGPoint, scale: CGFloat, duration: TimeInterval) {
    let rescale = SKAction.scale(to: scale, duration: duration)
    let movement = SKAction.move(to: pos, duration: duration)
    let zoom = SKAction.group([rescale, movement])
    let cameraSeq = SKAction.sequence([SKAction.wait(forDuration: duration), zoom])
    self.camera?.run(cameraSeq)
  }
  
  private func mapViewTransition() {
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
  }
  
  private func targetLocationTransition() {
    nextTargetLocation = (childNode(withName : "Marker-\(sceneNumber)") as! SKSpriteNode)
    nextTargetLocation?.zPosition = 1
    targetLocation.zPosition = 2
    
    // Transition between target
    let oldActionsSeq = SKAction.sequence([SKAction.wait(forDuration: 0.8), SKAction.fadeOut(withDuration: 1)])
    let newActionsSeq = SKAction.sequence([SKAction.wait(forDuration: 1.5), SKAction.fadeIn(withDuration: 1)])
    targetLocation.run(oldActionsSeq)
    nextTargetLocation?.run(newActionsSeq)
    
    targetLocation = nextTargetLocation!
    targetInitialScale = targetLocation.xScale
  }
  
  private func targetLocationNameTransition() {
    nextTargetLocationName = (childNode(withName : "MarkerText-\(sceneNumber)") as! SKLabelNode)
    nextTargetLocationName?.zPosition = 1
    targetLocationName.zPosition = 2
    
    // Transition between nodes
    let oldActionsSeq = SKAction.sequence([SKAction.wait(forDuration: 0.8), SKAction.fadeOut(withDuration: 1)])
    let newActionsSeq = SKAction.sequence([SKAction.wait(forDuration: 1.5), SKAction.fadeIn(withDuration: 1)])
    targetLocationName.run(oldActionsSeq)
    nextTargetLocationName?.run(newActionsSeq)
    
    nextTargetLocationName!.text = NSLocalizedString("LiseLocationName\(sceneNumber)", comment: "Comment")
    nextTargetLocationName!.fontColor = .white
    nextTargetLocationName!.fontSize = 15 * CGFloat(sceneNumber)
    nextTargetLocationName!.fontName = "NewYorkSmall-MediumItalic"
    
    targetLocationName = nextTargetLocationName!
  }
  
  private func changeMapView() {
    sceneNumber = sceneNumber + 1
    
    if sceneNumber < totalScenes - 1 {
      // Disables pinch untill map view changes
      isTransitioning = true
      
      mapViewTransition()
      targetLocationTransition()
      targetLocationNameTransition()
      
      getLineEquation()
      
      rescaleCameraOnViewChange(pos: CGPoint(x: 0, y: 0), scale: 1.0, duration: 2)
    }
    else {
      mapViewTransition()
      
      targetLocation.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.fadeOut(withDuration: 0.5)]))
      targetLocation.zPosition = 2
      rescaleCameraOnViewChange(pos: CGPoint(x: 0, y: 0), scale: 1.0, duration: 1)
      
      SceneTransition.executeDefaultTransition(
        from: self,
        to: LisePlayingScene.create(),
        nextSceneScaleMode: .aspectFill,
        transition: SKTransition.fade(withDuration: 2)
      )
    }
  }
  
  func touchDown(atPoint pos : CGPoint) {
    tooltipManager.stopAnimation()
    
    if targetLocation.contains(pos) && didReachTarget {
      hapticsManager?.triggerSuccess()
      
      changeMapView()
      
      if sceneNumber < totalScenes - 1 {
        configureTooltipForPinchIn()
        tooltipManager.startAnimation()
      }
    }
  }
  
  func touchMoved(toPoint pos : CGPoint) {
  }
  
  func touchUp(atPoint pos : CGPoint) {
    if sceneNumber < totalScenes - 1 && !isTransitioning {
      tooltipManager.startAnimation()
    }
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

