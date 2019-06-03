//
//  GameScene.swift
//  SpriteKit Example
//
//  Created by Jeans, Thomas on 1/15/16.
//  Copyright (c) 2016 Jeans, Thomas. All rights reserved.
//

import SpriteKit

// MARK: Base Class Definition
class GameScene: SKScene {

    var gameDidStart = false
    var gameOver = false
    var didRunGameOverSequence = false

    let playerCategory: UInt32 = 1 << 0
    let platformCategory: UInt32 = 1 << 1
    
    var playerXScaleFactor: CGFloat = 1.0
    var playerYScaleFactor: CGFloat = 1.0
    
    var createPlatformCounter = 0
    var createPlatformDelay: Int = 0
    var platformWidth: Int = 0
    var platformHeight: Int = 0

    var randomDelay: Int {
        var rd: UInt32
        
        repeat {
            rd = arc4random() % MAX_DELAY
        } while rd < MIN_DELAY
        
        return Int(rd)
    }
    
    var randomPlatformWidth: Int {
        var rpw: UInt32
        
        repeat {
            rpw = arc4random() % MAX_PLATFORM_WIDTH
        } while rpw < MIN_PLATFORM_WIDTH
        
        return Int(rpw)
    }
    
    var randomPlatformHeight: Int {
        var rph: UInt32
        
        repeat {
            rph = arc4random() % MAX_PLATFORM_WIDTH
        } while rph < MIN_PLATFORM_HEIGHT
        
        return Int(rph)
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        createBackgroundSprites()
        createPlatformSprite(initial: true)
        createPlayerSprite()
        setUpHUD()
        setUpLight()
        
        physicsWorld.contactDelegate = self
        
        if let timeInterval: TimeInterval = TimeInterval(exactly: 1.0/60.0) {
            Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { (_) in
                
                if self.gameDidStart && !self.gameOver {
                    
                    self.scrollBackground()
                    self.scrollPlatforms()
                    self.createPlatforms()
                    self.checkPlayerState()
                }
                
                if self.gameOver && !self.didRunGameOverSequence {
                    self.gameOverSequence()
                }
            }
        }
    }
    
    func createBackgroundSprites() {
        for i in 0..<2 {
            let backgroundSprite = SKSpriteNode(imageNamed: "es-background")
            backgroundSprite.size = CGSize(width: frame.size.width, height: frame.size.height)
            backgroundSprite.anchorPoint = .zero
            backgroundSprite.position = CGPoint(x: frame.size.width * CGFloat(i), y: 0)
            backgroundSprite.zPosition = 0
            backgroundSprite.name = "backgroundSprite"

            addChild(backgroundSprite)
        }
    }

    func createPlatformSprite(initial: Bool) {
        if initial {
            for i in 0..<INITIAL_PLATFORM_WIDTH {
                for j in 0..<INITIAL_PLATFORM_HEIGHT {
                    let platformTile = SKSpriteNode(imageNamed: "es-tile")
                    platformTile.anchorPoint = .zero
                    platformTile.position = CGPoint(x: platformTile.frame.size.width * CGFloat(i), y: platformTile.frame.size.height * CGFloat(j))
                    platformTile.zPosition = 1
                    platformTile.name = "platformTileSprite"

                    // TODO: Add Physics Body
                    platformTile.physicsBody = SKPhysicsBody(rectangleOf: platformTile.size, center: CGPoint(x: platformTile.frame.width * 0.5, y: platformTile.frame.height * 0.5))
                    platformTile.physicsBody?.isDynamic = false
                    platformTile.physicsBody?.affectedByGravity = false
                    platformTile.physicsBody?.restitution = 0.125
                    platformTile.physicsBody?.linearDamping = 0.0
                    platformTile.physicsBody?.allowsRotation = false
                    platformTile.physicsBody?.categoryBitMask = platformCategory
                    platformTile.physicsBody?.contactTestBitMask = playerCategory
                    platformTile.physicsBody?.collisionBitMask = 1
                    platformTile.physicsBody?.usesPreciseCollisionDetection = true

                    addChild(platformTile)
                }
            }

        } else {

            platformWidth = randomPlatformWidth
            platformHeight = randomPlatformHeight

            for i in 0..<platformWidth {
                for j in 0..<platformHeight {
                    let platformTile = SKSpriteNode(imageNamed: "es-tile")
                    platformTile.anchorPoint = .zero
                    platformTile.position = CGPoint(x: frame.size.width + (platformTile.frame.size.width * CGFloat(i)), y:  platformTile.frame.size.height * CGFloat(j))
                    platformTile.zPosition = 1
                    platformTile.name = "platformTileSprite"

                    // TODO: Add Physics Body
                    platformTile.physicsBody = SKPhysicsBody(rectangleOf: platformTile.size, center: CGPoint(x: platformTile.frame.width * 0.5, y: platformTile.frame.height * 0.5))
                    platformTile.physicsBody?.isDynamic = false
                    platformTile.physicsBody?.affectedByGravity = false
                    platformTile.physicsBody?.restitution = 0.125
                    platformTile.physicsBody?.linearDamping = 0.0
                    platformTile.physicsBody?.allowsRotation = false
                    platformTile.physicsBody?.categoryBitMask = platformCategory
                    platformTile.physicsBody?.contactTestBitMask = playerCategory
                    platformTile.physicsBody?.collisionBitMask = 1
                    platformTile.physicsBody?.usesPreciseCollisionDetection = true

                    addChild(platformTile)
                }
            }
        }
    }

    func createPlayerSprite() {
        if let platformTile = childNode(withName: "platformTileSprite") {
            let platformTileSpriteNode = platformTile as! SKSpriteNode

            let playerSprite = PlayerSpriteNode(imageNamed: "es-player")
            playerSprite.position = CGPoint(x: frame.size.width * 0.25, y:  (platformTileSpriteNode.size.height * CGFloat(INITIAL_PLATFORM_HEIGHT)) + (playerSprite.size.height * 0.5))
            playerSprite.zPosition = 1
            playerSprite.xScale = playerXScaleFactor
            playerSprite.yScale = playerYScaleFactor
            playerSprite.name = "playerSprite"

            // TODO: Add Physics Body
            playerSprite.physicsBody = SKPhysicsBody(rectangleOf: playerSprite.size)
            playerSprite.physicsBody?.isDynamic = true
            playerSprite.physicsBody?.affectedByGravity = true
            playerSprite.physicsBody?.restitution = 0.5
            playerSprite.physicsBody?.linearDamping = 0.0
            playerSprite.physicsBody?.allowsRotation = false
//            playerSprite.physicsBody?.categoryBitMask = playerCategory
//            playerSprite.physicsBody?.contactTestBitMask = playerCategory
            playerSprite.physicsBody?.usesPreciseCollisionDetection = true
            
            // TODO: Add Lighting Bit Masks
            playerSprite.shadowCastBitMask = 1
            playerSprite.lightingBitMask = 1

            addChild(playerSprite)
        }
    }

    func setUpLight() {
        let lightNode = SKLightNode()
        lightNode.position = CGPoint(x: view!.frame.size.width * 0.5, y: view!.frame.size.height * 0.75)
        lightNode.zPosition = 1
        lightNode.categoryBitMask = 1
        lightNode.falloff = 1.0
        lightNode.ambientColor = UIColor.white
        lightNode.shadowColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 0.25)
        lightNode.name = "lightNode"
        
        addChild(lightNode)
    }
    
    func setUpHUD() {
        let playLabel = SKLabelNode(fontNamed: FONT_NAME)
        playLabel.text = "TAP TO START"
        playLabel.fontSize = FONT_SIZE_TITLE
        playLabel.fontColor = UIColor.white
        playLabel.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        playLabel.zPosition = 2
        playLabel.name = "playLabel"
        addChild(playLabel)
    }

    func gameOverSequence() {
        didRunGameOverSequence = true

        let playAgainLabel = SKLabelNode(fontNamed: FONT_NAME)
        playAgainLabel.text = "PLAY AGAIN"
        playAgainLabel.fontSize = FONT_SIZE_TITLE
        playAgainLabel.fontColor = UIColor.white
        playAgainLabel.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        playAgainLabel.zPosition = 2
        playAgainLabel.name = "playAgainLabel"
        addChild(playAgainLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameDidStart && !gameOver {
            if let playerSprite: PlayerSpriteNode = childNode(withName: "playerSprite") as? PlayerSpriteNode {
                playerSprite.jump()
            }
        }
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if let playLabel: SKLabelNode = childNode(withName: "playLabel") as? SKLabelNode {
                if playLabel.contains(location) {
                    playLabel.removeFromParent()
                    gameDidStart = true
                    
                    if let playerSprite: PlayerSpriteNode = childNode(withName: "playerSprite") as? PlayerSpriteNode {
                        playerSprite.run()
                    }
                }
            }
            
            if let playAgainLabel: SKLabelNode = childNode(withName: "playAgainLabel") as? SKLabelNode {
                if playAgainLabel.contains(location) {
                    let newGameScene: GameScene = GameScene(size: size)
                    view?.presentScene(newGameScene, transition: SKTransition.fade(withDuration: 0.5))
                }
            }
        }
    }
}

// MARK: Physics Contact Delegate
extension GameScene: SKPhysicsContactDelegate {

    func didBegin(_ contact: SKPhysicsContact) {
        if let playerSprite: PlayerSpriteNode = childNode(withName: "playerSprite") as? PlayerSpriteNode {
            if !gameOver && gameDidStart {
                playerSprite.run()
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        //
    }
}

// MARK: Update Methods
extension GameScene {
    
    func scrollBackground() {
        enumerateChildNodes(withName: "backgroundSprite") { (node, _) -> Void in
            node.position = CGPoint(x: node.position.x - BACKGROUND_SPRITE_SCROLL_RATE, y: node.position.y)
            if node.position.x <= -self.frame.size.width {
                node.position = CGPoint(x: node.position.x + self.frame.size.width * 2, y:  node.position.y)
            }
        }
    }
    
    func scrollPlatforms() {
        enumerateChildNodes(withName: "platformTileSprite") { (node, _) -> Void in
            node.position = CGPoint(x: node.position.x - PLATFORM_TILE_SPRITE_SCROLL_RATE, y: node.position.y)
            if node.position.x < -node.frame.size.width {
                node .removeFromParent()
            }
        }
    }
    
    func createPlatforms() {
        createPlatformCounter += 1
        
        if (createPlatformCounter > createPlatformDelay) {
            createPlatformCounter = 0
            createPlatformDelay = randomDelay
            
            createPlatformSprite(initial: false)
        }
    }
    
    func checkPlayerState() {
        if let playerSprite = childNode(withName: "playerSprite") {
            if playerSprite.position.y < -playerSprite.position.y {
                gameOver = true
            }
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
//        if gameDidStart && !gameOver {
//
//            scrollBackground()
//            scrollPlatforms()
//            createPlatforms()
//            checkPlayerState()
//        }
//
//        if gameOver && !didRunGameOverSequence {
//            gameOverSequence()
//        }
    }
}
