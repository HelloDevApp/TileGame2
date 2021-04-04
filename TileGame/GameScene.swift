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
    
    let sheet = SpriteSheet(texture: SKTexture(imageNamed: "uni"), rows: 12, columns: 24, spacing: 1, margin: 1)
    
    override func didMove(to view: SKView) {
        
        
        fillGrassMapTile()
        setupPlayer()
        setupCamera()
        
        let angleUp = deg2rad(45)
        let angleDown = deg2rad(-135)
        let angleLeft = deg2rad(135)
        let angleRight = deg2rad(-45)
        
        setupSpriteButton(buttonSprite: &upButton, toAngle: angleUp)
        setupSpriteButton(buttonSprite: &downButton, toAngle: angleDown)
        setupSpriteButton(buttonSprite: &leftButton, toAngle: angleLeft)
        setupSpriteButton(buttonSprite: &rightButton, toAngle: angleRight)
        
        upButton.name = "btnUp"
        downButton.name = "btnDown"
        leftButton.name = "btnLeft"
        rightButton.name = "btnRight"
        
        camera!.addChild(upButton)
        camera!.addChild(downButton)
        camera!.addChild(leftButton)
        camera!.addChild(rightButton)
        
        upButton.position = CGPoint(x: -200, y: -40)
        downButton.position = CGPoint(x: -200, y: -160)
        leftButton.position = CGPoint(x: -260, y: -100)
        rightButton.position = CGPoint(x: -140, y: -100)
        
        walkRightAnimPlayer = createAnimTexturesFormSpriteSheet(row: 2, rangeTiles: 12...17)
        walkLeftAnimPlayer = createAnimTexturesFormSpriteSheet(row: 3, rangeTiles: 18...23)
        walkOfFaceAnimPlayer = createAnimTexturesFormSpriteSheet(row: 2, rangeTiles: 6...11)
        walkBackAnimPlayer = createAnimTexturesFormSpriteSheet(row: 3, rangeTiles: 6...11)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        let positionInScene = touch!.location(in: self)
        touchedNode = self.atPoint(positionInScene)
        
        buttonIsTapped = true
        
        if let name = touchedNode?.name, buttonIsTapped {
            if name == "btnUp" {
                upButtonIsTapped = true
                print("upButton tapped")
                player.texture = sheet.textureForColumn(column: 6, row: 3)
                player.run(.repeatForever(walkBackAnimPlayer), withKey: "walkBack")
            }
            
            if name == "btnDown" {
                downButtonIsTapped = true
                print("downButton tapped")
                player.texture = sheet.textureForColumn(column: 6, row: 2)
                player.run(.repeatForever(walkOfFaceAnimPlayer), withKey: "walkFace")
            }
            
            if name == "btnLeft" {
                leftButtonIsTapped = true
                print("leftButton tapped")
                player.texture = sheet.textureForColumn(column: 18, row: 3)
                player.run(.repeatForever(walkLeftAnimPlayer), withKey: "walkLeft")
            }
            
            if name == "btnRight" {
                rightButtonIsTapped = true
                print("rightButton tapped")
                player.texture = sheet.textureForColumn(column: 12, row: 2)
                player.run(.repeatForever(walkRightAnimPlayer), withKey: "walkRight")
                
            }
        }
       
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if upButtonIsTapped { upButtonIsTapped = false }
        if downButtonIsTapped { downButtonIsTapped = false }
        if leftButtonIsTapped { leftButtonIsTapped = false }
        if rightButtonIsTapped { rightButtonIsTapped = false }
        
        if upButtonIsTapped == false && downButtonIsTapped == false && leftButtonIsTapped == false && rightButtonIsTapped == false {
            buttonIsTapped = false
        }
        
        player.removeAction(forKey: "walkRight")
        player.removeAction(forKey: "walkLeft")
        player.removeAction(forKey: "walkFace")
        player.removeAction(forKey: "walkBack")
    }
    
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonIsTapped = false
        
        if upButtonIsTapped { upButtonIsTapped = false }
        if downButtonIsTapped { downButtonIsTapped = false }
        if leftButtonIsTapped { leftButtonIsTapped = false }
        if rightButtonIsTapped { rightButtonIsTapped = false }
        
        player.removeAction(forKey: "walkLeft")
        player.removeAction(forKey: "walkRight")
        player.removeAction(forKey: "walkFace")
        player.removeAction(forKey: "walkBack")
    }
    
    override func update(_ currentTime: TimeInterval) {
        updatePostitionPlayer()
    }
    
    fileprivate func updatePostitionPlayer() {
        if let name = touchedNode?.name {
            if name == "btnUp", upButtonIsTapped {
                player.position.x += 4
                player.position.y += 2
            }
            
            if name == "btnDown", downButtonIsTapped {
                player.position.x -= 4
                player.position.y -= 2
            }
            
            if name == "btnLeft", leftButtonIsTapped {
                player.position.x -= 4
                player.position.y += 2
            }
            
            if name == "btnRight", rightButtonIsTapped {
                player.position.x += 4
                player.position.y -= 2
            }
        }
    }
    
    func fillGrassMapTile() {
        tileSet = SKTileSet(named: "GrassTileSet")
        
        tileMapGrassLevel_0 = SKTileMapNode(tileSet: tileSet!, columns: 10, rows: 10, tileSize: CGSize(width: 128, height: 64))
        addChild(tileMapGrassLevel_0!)
        
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
    
    func setupSpriteButton(buttonSprite: inout SKSpriteNode?, toAngle: CGFloat) {
        buttonSprite = SKSpriteNode(imageNamed: "arrow-576725")
        buttonSprite?.size = CGSize(width: 50, height: 50)
        buttonSprite?.run(.rotate(toAngle: toAngle, duration: 0, shortestUnitArc: true))
    }

    
    // Setup methods
    func setupCamera() {
        let camera = SKCameraNode()
        camera.position = CGPoint(x:0, y:0)
        camera.xScale = 1
        camera.yScale = 1

        addChild(camera)
        self.camera = camera
    
        camera.constraints = [SKConstraint.distance(SKRange(constantValue: 0), to: player)]
    }
    
    func setupPlayer() {
        player = SKSpriteNode(texture: sheet.textureForColumn(column: 6, row: 2))
        player.position = .zero
        
        tileMapGrassLevel_0?.addChild(player)
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
