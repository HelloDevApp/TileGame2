//
//  GameScene.swift
//  TileGame
//
//  Created by Dylan on 22/11/2020.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var tileSet: SKTileSet?
    
    // map 0
    private var tileMapGrassLevel_0: SKTileMapNode?
    // map 1
    
    // player
    private var player: SKSpriteNode!
    
    
    var shape: SKSpriteNode?
    
    var tilesGroup: [SKTileGroup]!
    
    // Previous Values
    var previousLocation: CGPoint!
    var previousScaleCamera: CGFloat!
    var previousPinchValue: CGFloat!
    
    override func didMove(to view: SKView) {
        
        setupCamera()
        
        let zoomGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoom(_:)))
        
        view.addGestureRecognizer(zoomGesture)
        
        // Tapped Gesture for Interaction with nodes
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(recognizer:)))
        tapGestureRecognizer.name = "tapped"
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
        
        fillGrassMapTile()
        setupPlayer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        
        previousLocation = touches.first!.previousLocation(in: self)
        let x = -(location.x - previousLocation.x)
        let y = -(location.y - previousLocation.y)
        
        camera?.position.x += x
        camera?.position.y += y
      }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("ended ^^")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("cancelled ^^")
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func fillGrassMapTile() {
        tileSet = SKTileSet(named: "GrassTileSet")
        
        tileMapGrassLevel_0 = SKTileMapNode(tileSet: tileSet!, columns: 10, rows: 10, tileSize: CGSize(width: 128, height: 64))
        scene?.addChild(tileMapGrassLevel_0!)
        
        // Global Groups
        tilesGroup = tileSet?.tileGroups
        guard let tilesGroup = tilesGroup else { return }
        
        // Groups In Global Groups
        guard let grassGroup = tilesGroup.first(where: { $0.name == "GrassGroup" }) else {
            fatalError("No grass group found")
        }
        
        guard let objectGroup = tilesGroup.first(where: { $0.name == "ObjectGroup" }) else {
            fatalError("No object group found")
        }
        
        // Rules
        guard let woodFlowerRule = objectGroup.rules.first(where: { $0.name == "WoodFlower" }) else {
            fatalError(" No grass group rule tile found")
        }
        
        // Tiles
        guard let woodFlowerTile = woodFlowerRule.tileDefinitions.first(where: { $0.name == "WoodFlowerTile" }) else {
            fatalError(" no grassCenter tile found")
        }
        
        
        print("GrassCenter: \(woodFlowerTile)")
        tileMapGrassLevel_0?.fill(with: grassGroup)
        tileMapGrassLevel_0?.setTileGroup(objectGroup, andTileDefinition: woodFlowerTile, forColumn: 1, row: 0)
        tileMapGrassLevel_0?.setTileGroup(objectGroup, andTileDefinition: woodFlowerTile, forColumn: 3, row: 0)
        
        tileMapGrassLevel_0?.setTileGroup(objectGroup, andTileDefinition: woodFlowerTile, forColumn: 1, row: 3)
        tileMapGrassLevel_0?.setTileGroup(objectGroup, andTileDefinition: woodFlowerTile, forColumn: 3, row: 3)
    }
    
    
    @objc func zoom(_ sender: UIPinchGestureRecognizer) {
        
        if previousPinchValue == nil {
            previousPinchValue = sender.scale
        }
        
        if previousPinchValue < sender.scale { // BACK ZOOM
            camera?.xScale -= 0.05
            camera?.yScale -= 0.05
            previousPinchValue = sender.scale
            
        } else if previousPinchValue > sender.scale { // ZOOM
            camera?.xScale += 0.05
            camera?.yScale += 0.05
            previousPinchValue = sender.scale
        }
        
    }
    
    @objc func handleTapFrom(recognizer: UITapGestureRecognizer) {
        
        if recognizer.name == "tapped" {
            if recognizer.state != .ended {
                return
            }
            
            print("ok")
            let recognizorLocation = recognizer.location(in: recognizer.view!)
            let location = self.convertPoint(fromView: recognizorLocation)
            
            guard let map = tileMapGrassLevel_0 else {
                fatalError("Background node not loaded")
            }
            let column = map.tileColumnIndex(fromPosition: location)
            let row = map.tileRowIndex(fromPosition: location)
            let tile = map.tileDefinition(atColumn: column, row: row)
            
            let grassTile = tilesGroup.first(where: {$0.name == "GrassGroup"})
            
            if tile != nil {
                let emptyTile = SKTileGroup.empty()
                map.setTileGroup(emptyTile, forColumn: column, row: row)
            } else {
                
                map.setTileGroup(grassTile, forColumn: column, row: row)
            }
        } else { return }
    }
    
    // Setup methods
    func setupCamera() {
        let camera = SKCameraNode()
        camera.position = CGPoint(x:0, y:0)
        camera.xScale = 1
        camera.yScale = 1
        
        scene?.addChild(camera)
        scene?.camera = camera
    }
    
    func setupPlayer() {
        player = SKSpriteNode(color: .blue, size: CGSize(width: 100, height: 100))
        player.position = .zero
        player.texture = .init(image: #imageLiteral(resourceName: "Tree_Iso"))
        addChild(player)
    }
    
}





// ----------------------
// ADD SPRITE Color to colored tile clicked
// ----------------------

//            zoomGesture.cancelsTouchesInView = false
//            let group = map.tileGroup(atColumn: column, row: row)
//            let centerOfTile = tileMapGrassLevel_0?.centerOfTile(atColumn: column, row: row)
//            shape = SKSpriteNode(color: .black, size: CGSize(width: tileMapGrassLevel_0!.tileSize.height * tileMapGrassLevel_0!.yScale, height: tileMapGrassLevel_0!.tileSize.height * tileMapGrassLevel_0!.xScale))
//            shape?.position = centerOfTile!
//            shape?.alpha = 0.3
//            addChild(shape!)
