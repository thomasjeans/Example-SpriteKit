//
//  GameScene.swift
//  SpriteKit Example
//
//  Created by Jeans, Thomas on 1/15/16.
//  Copyright (c) 2016 Jeans, Thomas. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var gameDidStart = false
    var gameOver = false
    var didRunGameOverSequence = false

    let playerCategory: UInt32 = 1 << 0
    let platformCategory: UInt32 = 1 << 1
    
    var createPlatformCounter = 0
    var createPlatformDelay: Int?
    var platformWidth: Int?
    var platformHeight: Int?

    var randomDelay: Int {
        get {
            var rd: UInt32
            
            repeat {
                rd = arc4random() % MAX_DELAY
            } while rd < MIN_DELAY
            
            return Int(rd)
        }
    }
    
    var randomPlatformWidth: Int {
        get {
            var rpw: UInt32
            
            repeat {
                rpw = arc4random() % MAX_PLATFORM_WIDTH
            } while rpw < MIN_PLATFORM_WIDTH
            
            return Int(rpw)
        }
    }
    
    var randomPlatformHeight: Int {
        get {
            var rph: UInt32
            
            repeat {
                rph = arc4random() % MAX_PLATFORM_WIDTH
            } while rph < MIN_PLATFORM_HEIGHT
            
            return Int(rph)
        }
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        physicsWorld.contactDelegate = self
        
        createBackgroundSprites()
        createPlatformSpriteInitial(true)
        createPlayerSprite()
        setUpHUD()
        setUpLight()
    }

    func createBackgroundSprites() {
        for var i = 0; i < 2; i++ {
            let backgroundSprite = SKSpriteNode(imageNamed: "es-background")
            backgroundSprite.size = CGSizeMake(frame.size.width, frame.size.height)
            backgroundSprite.anchorPoint = CGPointZero
            backgroundSprite.position = CGPointMake(frame.size.width * CGFloat(i), 0)
            backgroundSprite.zPosition = 0
            backgroundSprite.name = "backgroundSprite"

            addChild(backgroundSprite)
        }
    }

    func createPlatformSpriteInitial(initial: Bool) {
        if initial == true {
            for var i = 0; i < INITIAL_PLATFORM_WIDTH; i++ {
                for var j = 0; j < INITIAL_PLATFORM_HEIGHT; j++ {
                    let platformTile = SKSpriteNode(imageNamed: "es-tile")
                    platformTile.anchorPoint = CGPointZero
                    platformTile.position = CGPointMake(platformTile.frame.size.width * CGFloat(i), platformTile.frame.size.height * CGFloat(j))
                    platformTile.zPosition = 1
                    platformTile.name = "platformTileSprite"

                    // TODO: Add Physics Body
                    platformTile.physicsBody = SKPhysicsBody(rectangleOfSize: platformTile.size, center: CGPointMake(platformTile.frame.width * 0.5, platformTile.frame.height * 0.5))
                    platformTile.physicsBody?.dynamic = false
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

            for var i = 0; i < platformWidth; i++ {
                for var j = 0; j < platformHeight; j++ {
                    let platformTile = SKSpriteNode(imageNamed: "es-tile")
                    platformTile.anchorPoint = CGPointZero
                    platformTile.position = CGPointMake(frame.size.width + (platformTile.frame.size.width * CGFloat(i)), platformTile.frame.size.height * CGFloat(j))
                    platformTile.zPosition = 1
                    platformTile.name = "platformTileSprite"

                    // TODO: Add Physics Body
                    platformTile.physicsBody = SKPhysicsBody(rectangleOfSize: platformTile.size, center: CGPointMake(platformTile.frame.width * 0.5, platformTile.frame.height * 0.5))
                    platformTile.physicsBody?.dynamic = false
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
        if let platformTile = childNodeWithName("platformTileSprite") {
            let platformTileSpriteNode = platformTile as! SKSpriteNode

            let playerSprite = PlayerSpriteNode(imageNamed: "es-player")
            playerSprite.position = CGPointMake(frame.size.width * 0.25, (platformTileSpriteNode.size.height * CGFloat(INITIAL_PLATFORM_HEIGHT)) + (playerSprite.size.height * 0.5))
            playerSprite.zPosition = 1
            playerSprite.name = "playerSprite"

            // TODO: Add Physics Body
            playerSprite.physicsBody = SKPhysicsBody(rectangleOfSize: playerSprite.size)
            playerSprite.physicsBody?.dynamic = true
            playerSprite.physicsBody?.affectedByGravity = true
            playerSprite.physicsBody?.restitution = 0.5
            playerSprite.physicsBody?.linearDamping = 0.0
            playerSprite.physicsBody?.allowsRotation = false
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
        lightNode.ambientColor = UIColor.whiteColor()
        lightNode.shadowColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 0.25)
        lightNode.name = "lightNode"
        
        addChild(lightNode)
    }
    
    func setUpHUD() {
        let playLabel = SKLabelNode(fontNamed: FONT_NAME)
        playLabel.text = "TAP TO START"
        playLabel.fontSize = 30
        playLabel.fontColor = UIColor.whiteColor()
        playLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        playLabel.zPosition = 2
        playLabel.name = "playLabel"
        addChild(playLabel)
    }

    func gameOverSequence() {
        didRunGameOverSequence = true

        let playAgainLabel = SKLabelNode(fontNamed: FONT_NAME)
        playAgainLabel.text = "PLAY AGAIN"
        playAgainLabel.fontSize = 30
        playAgainLabel.fontColor = UIColor.whiteColor()
        playAgainLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        playAgainLabel.zPosition = 2
        playAgainLabel.name = "playAgainLabel"
        addChild(playAgainLabel)
    }

    func didBeginContact(contact: SKPhysicsContact) {
        if let playerSprite: PlayerSpriteNode = childNodeWithName("playerSprite") as? PlayerSpriteNode {
            if !gameOver && gameDidStart {
                playerSprite.run()
            }
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */

        if gameDidStart && !gameOver {
            if let playerSprite: PlayerSpriteNode = childNodeWithName("playerSprite") as? PlayerSpriteNode {
                playerSprite.jump()
            }
        }

        for touch in touches {
            let location = touch.locationInNode(self)

            if let playLabel: SKLabelNode = childNodeWithName("playLabel") as? SKLabelNode {
                if playLabel.containsPoint(location) {
                    playLabel.removeFromParent()
                    gameDidStart = true

                    if let playerSprite: PlayerSpriteNode = childNodeWithName("playerSprite") as? PlayerSpriteNode {
                        playerSprite.run()
                    }
                }
            }

            if let playAgainLabel: SKLabelNode = childNodeWithName("playAgainLabel") as? SKLabelNode {
                if playAgainLabel.containsPoint(location) {
                    let newGameScene: GameScene = GameScene(size: size)
                    view?.presentScene(newGameScene, transition: SKTransition.fadeWithDuration(0.5))
                }
            }
        }
    }

    func scrollBackgroundForUpdate() {
        enumerateChildNodesWithName("backgroundSprite") { (node, _) -> Void in
            node.position = CGPointMake(node.position.x - BACKGROUND_SPRITE_SCROLL_RATE, node.position.y)
            if node.position.x <= -self.frame.size.width {
                node.position = CGPointMake(node.position.x + self.frame.size.width * 2, node.position.y)
            }
        }
    }

    func scrollPlatformsForUpdate() {
        enumerateChildNodesWithName("platformTileSprite") { (node, _) -> Void in
            node.position = CGPointMake(node.position.x - PLATFORM_TILE_SPRITE_SCROLL_RATE, node.position.y)
            if node.position.x < -node.frame.size.width {
                node .removeFromParent()
            }
        }
    }

    func createPlatformsForUpdate() {
        createPlatformCounter++
        
        if (createPlatformCounter > createPlatformDelay) {
            createPlatformCounter = 0
            createPlatformDelay = randomDelay
            
            createPlatformSpriteInitial(false)
        }
    }
    
    func checkPlayerStateForUpdate() {
        if let playerSprite = childNodeWithName("playerSprite") {
            if playerSprite.position.y < -playerSprite.position.y {
                gameOver = true
            }
        }
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

        if gameDidStart && !gameOver {

            scrollBackgroundForUpdate()
            scrollPlatformsForUpdate()
            createPlatformsForUpdate()
            checkPlayerStateForUpdate()
        }
        
        if gameOver && !didRunGameOverSequence {
            gameOverSequence()
        }
    }
}
