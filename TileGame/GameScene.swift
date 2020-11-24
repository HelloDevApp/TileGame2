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
    
    var tilesGroup: [SKTileGroup]!
    
    override func didMove(to view: SKView) {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(recognizer:)))
            tapGestureRecognizer.numberOfTapsRequired = 1
            view.addGestureRecognizer(tapGestureRecognizer)
        
        fillGrassMapTile()
    }
    
    func fillGrassMapTile() {
        tileSet = SKTileSet(named: "GrassTileSet")
        
        tileMapGrassLevel_0 = SKTileMapNode(tileSet: tileSet!, columns: 5, rows: 4, tileSize: CGSize(width: 128, height: 64))
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
    
    @objc func handleTapFrom(recognizer: UITapGestureRecognizer) {
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
        let group = map.tileGroup(atColumn: column, row: row)
        
        print("\ncolonne:")
        print(column)
        print("row:")
        print(row)
        print("\n")
        let grassTile = tilesGroup.first(where: {$0.name == "GrassGroup"})
        
        if tile != nil {
            let emptyTile = SKTileGroup.empty()
            map.setTileGroup(emptyTile, forColumn: column, row: row)
        } else {
            map.setTileGroup(grassTile, forColumn: column, row: row)
        }
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func update(_ currentTime: TimeInterval) {}
}
