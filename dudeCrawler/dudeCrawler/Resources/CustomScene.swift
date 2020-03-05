//
//  CustomScene.swift
//  Contained
//
//  Created by Jake Connerly on 7/22/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//


import Foundation
import SpriteKit

enum SpriteMovement: String {
    case north
    case east
    case south
    case west
    case idle
}

enum SpriteNames: String {
    case dudeWalk
    case dudeIdle
}

class CustomScene: SKScene {
    let dude = SKSpriteNode()
    
    // Add and center child, initializing animation sequence
    override func sceneDidLoad() {
        super.sceneDidLoad()
        addChild(dude)
        dude.loadTextures(named: Settings.shared.dude, forKey: SKSpriteNode.textureKey)
        dude.position = Settings.shared.position
    }
    
    func moveSpriteHorizontal(position: CGFloat) {
        Settings.shared.dude = SpriteNames.dudeWalk.rawValue
        dude.loadTextures(named: Settings.shared.dude, forKey: SKSpriteNode.textureKey)
        dude.position = Settings.shared.position
        let moveLeftRight = SKAction.moveTo(x: position, duration: 2.0)
        let fade = SKAction.fadeOut(withDuration: 2.0)
        dude.run(fade, withKey: "fade")
        dude.run(moveLeftRight) {
            let fadeIn = SKAction.fadeIn(withDuration: 0.01)
            self.dude.run(fadeIn)
            self.dude.removeAction(forKey: "fade")
            self.dude.position = Settings.shared.position
            Settings.shared.dude = SpriteNames.dudeIdle.rawValue
            self.dude.loadTextures(named: Settings.shared.dude, forKey: SKSpriteNode.textureKey)
        }
    }
    
    func moveSpriteVertical(position: CGFloat) {
        Settings.shared.dude = SpriteNames.dudeWalk.rawValue
        dude.loadTextures(named: Settings.shared.dude, forKey: SKSpriteNode.textureKey)
        dude.position = Settings.shared.position
        let moveUpDown = SKAction.moveTo(y: position, duration: 2.0)
        let fade = SKAction.fadeOut(withDuration: 2.0)
        dude.run(fade, withKey: "fade")
        dude.run(moveUpDown) {
            let fadeIn = SKAction.fadeIn(withDuration: 0.01)
            self.dude.run(fadeIn)
            self.dude.removeAction(forKey: "fade")
            self.dude.position = Settings.shared.position
            Settings.shared.dude = SpriteNames.dudeIdle.rawValue
            self.dude.loadTextures(named: Settings.shared.dude, forKey: SKSpriteNode.textureKey)
        }
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
