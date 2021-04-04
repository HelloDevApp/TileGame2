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
    
    
    var upButton: SKSpriteNode!
    var downButton: SKSpriteNode!
    var leftButton: SKSpriteNode!
    var rightButton: SKSpriteNode!
    
    var walkRightAnimPlayer: SKAction!
    var walkLeftAnimPlayer: SKAction!
    var walkOfFaceAnimPlayer: SKAction!
    var walkBackAnimPlayer: SKAction!
    
    var touchedNode: SKNode?
    
    var buttonIsTapped = false
    var upButtonIsTapped = false
    var downButtonIsTapped = false
    var leftButtonIsTapped = false
    var rightButtonIsTapped = false
    
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
    
    func createAnimTexturesFormSpriteSheet(row: Int, rangeTiles: ClosedRange<Int>) -> SKAction  {
        var texturesAnimationPlayer = [SKTexture]()
        

        for i in rangeTiles {
            texturesAnimationPlayer.append(sheet.textureForColumn(column: i, row: row)!)
        }
        
        return SKAction.animate(with: texturesAnimationPlayer,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true)
    }
    
    func deg2rad(_ number: Double) -> CGFloat {
        return CGFloat((number * .pi) / 180)
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







//        setupSpriteButton(buttonSprite: &upButton, toAngle: (CGFloat.pi / 2))
//        setupSpriteButton(buttonSprite: &downButton, toAngle: -(CGFloat.pi / 2))
//        setupSpriteButton(buttonSprite: &leftButton, toAngle: CGFloat.pi)
//        setupSpriteButton(buttonSprite: &rightButton, toAngle: 0)


//    func setupSpriteButton(buttonSprite: inout SKSpriteNode?, toAngle: CGFloat) {
//        buttonSprite = SKSpriteNode(imageNamed: "arrow-576725")
//        buttonSprite?.size = CGSize(width: 50, height: 50)
//        buttonSprite?.run(.rotate(toAngle: toAngle, duration: 0, shortestUnitArc: true))
//    }




//        upButton.position = CGPoint(x: -200, y: -40)
//        downButton.position = CGPoint(x: -200, y: -160)
//        leftButton.position = CGPoint(x: -260, y: -100)
//        rightButton.position = CGPoint(x: -140, y: -100)
