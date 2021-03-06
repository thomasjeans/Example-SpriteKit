//
//  PlayerSpriteNode.swift
//  SpriteKit Example
//
//  Created by Jeans, Thomas on 1/22/16.
//  Copyright © 2016 Jeans, Thomas. All rights reserved.
//

import SpriteKit

class PlayerSpriteNode: SKSpriteNode {

    var runCycleTexture0: SKTexture = SKTexture(imageNamed: "es-run_0")
    var runCycleTexture1: SKTexture = SKTexture(imageNamed: "es-run_1")
    var runCycleTexture2: SKTexture = SKTexture(imageNamed: "es-run_2")
    var runCycleTexture3: SKTexture = SKTexture(imageNamed: "es-run_3")

    var jumpCount = 0
    var actionCount = 0

    func run() {
        jumpCount = 0

        actionCount += 1

        if actionCount <= MAX_ACTIONS_ALLOWED {
            run(SKAction.repeatForever(SKAction.animate(with: [runCycleTexture0, runCycleTexture1, runCycleTexture2, runCycleTexture3], timePerFrame: 0.125)))
        }
    }

    func jump() {
        actionCount = 0

        jumpCount += 1

        if jumpCount <= MAX_JUMPS_ALLOWED {
            removeAllActions()
            texture = SKTexture(imageNamed: "es-player-jump")
            physicsBody?.velocity = CGVector(dx: JUMP_VELOCITY_DX, dy: JUMP_VELOCITY_DY)
            run(SKAction.playSoundFileNamed("es-jump.m4a", waitForCompletion: false))
        }
    }
}
