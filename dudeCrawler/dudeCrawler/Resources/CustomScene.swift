//
//  CustomScene.swift
//  Contained
//
//  Created by Jake Connerly on 7/22/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import SpriteKit

class CustomScene: SKScene {
    let dude = SKSpriteNode()
    
    // Add and center child, initializing animation sequence
    override func sceneDidLoad() {
        super.sceneDidLoad()
        addChild(dude)
        dude.loadTextures(named: Settings.shared.dude, forKey: SKSpriteNode.textureKey)
        dude.position = Settings.shared.position
    }
    
//    // Move to touch
//    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        // Fetch a touch or leave
//        guard !touches.isEmpty, let touch = touches.first else { return }
//
//        // Retrieve position
//        let position = touch.location(in: self)
//        Settings.shared.position = position
//
//        // Create move action
//        let actionDuration = 1.0
//        let moveAction = SKAction.move(to: position, duration: actionDuration)
//
//        let rollAction   = SKAction.rotate(byAngle: CGFloat.pi * 2, duration: actionDuration)
//        let zoomAction   = SKAction.scale(by: 1.3, duration: 0.3)
//        let unzoomAction = SKAction.scale(to: 1.0, duration: 0.1)
//        let soundAction  = SKAction.playSoundFileNamed("shortcrabsound", waitForCompletion: false)
        
        
        
        
//        switch Settings.shared.shouldZoom {
//        case false:
//            dude.run(soundAction)
//            dude.run(moveAction)
//        case true:
//            let sequenceAction = SKAction.sequence([soundAction, zoomAction, moveAction, unzoomAction])
//            dude.run(sequenceAction)
//        }
//        
//        if Settings.shared.shouldRoll {
//            dude.run(soundAction)
//            dude.run(rollAction)
//        }
//    }
}