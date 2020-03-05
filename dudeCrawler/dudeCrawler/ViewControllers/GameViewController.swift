//
//  GameViewController.swift
//  dudeCrawler
//
//  Created by Jake Connerly on 3/3/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import UIKit
import SpriteKit

enum Directions: String {
    case n
    case e
    case s
    case w
}

class GameViewController: UIViewController {
    
    // MARK: - IBOutlets & Properties

    @IBOutlet weak var skView1: SKView!
    @IBOutlet weak var scriptTextView: UITextView!
    @IBOutlet weak var northButton: UIButton!
    @IBOutlet weak var eastButton: UIButton!
    @IBOutlet weak var southButton: UIButton!
    @IBOutlet weak var westButton: UIButton!
    
    var skScene: CustomScene? = nil
    let signInController = SignInController()
    let myText = "Welcome To Dude Dungeon Crawler"
    var accessKey = KeychainWrapper.standard.string(forKey: "accessKey")
    var moveDirection: MoveDirection?
    var currentEnv: Enviornment?
    
    let gameController = GameController()
    
    // MARK: - View LifeCycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scriptTextView.text = ""
        animateText(text: myText)
        disableMoveButtons()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        skScene = CustomScene(size: view.bounds.size)
        skView1.presentScene(skScene)
        if accessKey == nil {
            performSegue(withIdentifier: "SignInSegue", sender: self)
        }
        disableMoveButtons()
    }
    
    // MARK: - IBActions & Methods
    
    private func animateText(text: String) {
        for char in text {
            scriptTextView.text! += "\(char)"
            RunLoop.current.run(until: Date() + 0.01)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.enableMoveButtons()
        }
    }
    
    private func disableMoveButtons() {
        northButton.isEnabled = false
        eastButton.isEnabled  = false
        southButton.isEnabled = false
        westButton.isEnabled  = false
    }
    
    @objc private func enableMoveButtons() {
        northButton.isEnabled = true
        eastButton.isEnabled  = true
        southButton.isEnabled = true
        westButton.isEnabled  = true
    }
    
    private func updateGameText() {
        scriptTextView.text = ""
        var gameText = ""
        guard let currentEnv = currentEnv else { return }
        if currentEnv.title == "Grand Overlook" {
            gameText = "Welcome \(currentEnv.name)!\n\nYou are currently at a \(currentEnv.title).\n\n\(currentEnv.description)..."
        } else {
            gameText = "\(currentEnv.name), you are currently in a \(currentEnv.title) and \(currentEnv.description).\n\n Which way will you go?"
        }
        animateText(text: gameText)
    }
    
    private func wrongWayAlert() {
        disableMoveButtons()
        let alertController = UIAlertController(title: "Oops!", message: "You can't go that way!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        enableMoveButtons()
    }
    
    @IBAction func startGameTapped(_ sender: UIButton) {
        guard let accessKey = accessKey else { return }
        gameController.startGameWith(token: accessKey) { (result) in
            if (try? result.get()) != nil {
                DispatchQueue.main.async {
                    self.currentEnv = self.gameController.enviornment
                    self.updateGameText()
                }
            } else {
                NSLog("Error logging in with \(result)")
            }
        }
    }
    
    @IBAction func moveButtonTapped(_ sender: UIButton) {
        print("BOOM! Move tap")
        disableMoveButtons()
        switch sender.tag {
        case 0:
            self.moveDirection = MoveDirection(direction: Directions.n.rawValue)
        case 1:
            self.moveDirection = MoveDirection(direction: Directions.e.rawValue)
        case 2:
            self.moveDirection = MoveDirection(direction: Directions.s.rawValue)
        case 3:
            self.moveDirection = MoveDirection(direction: Directions.w.rawValue)
        default:
            return
        }
        guard let accessKey = accessKey,
            let moveDir = moveDirection else { return }
        self.skScene?.wave()
        gameController.move(direction: moveDir, token: accessKey) { (result) in
            if (try? result.get()) != nil {
                DispatchQueue.main.async {
                    self.currentEnv = self.gameController.enviornment
                    switch sender.tag {
                    case 0:
                        //self.moveDirection = MoveDirection(direction: Directions.n.rawValue)
                        if self.currentEnv?.errorMessage == "" || self.currentEnv?.errorMessage == nil {
                            self.skScene?.moveSpriteVertical(position: 700)
                            self.updateGameText()
                        } else {
                            self.skScene?.jump(completion: { (didJump) in
                                if didJump == true {
                                    DispatchQueue.main.async {
                                        self.wrongWayAlert()
                                    }
                                }
                            })
                        }
                    case 1:
                        if self.currentEnv?.errorMessage == "" || self.currentEnv?.errorMessage == nil {
                            self.skScene?.moveSpriteHorizontal(position: self.skScene!.frame.size.width)
                            self.updateGameText()
                        } else {
                            self.skScene?.jump(completion: { (didJump) in
                                if didJump == true {
                                    DispatchQueue.main.async {
                                        self.wrongWayAlert()
                                    }
                                }
                            })
                        }
                    case 2:
                        if self.currentEnv?.errorMessage == "" || self.currentEnv?.errorMessage == nil {
                            self.skScene?.moveSpriteVertical(position: 0)
                            self.updateGameText()
                        } else {
                            self.skScene?.wave()
                            self.skScene?.jump(completion: { (didJump) in
                                if didJump == true {
                                    DispatchQueue.main.async {
                                        self.wrongWayAlert()
                                    }
                                }
                            })                        }
                    case 3:
                        if self.currentEnv?.errorMessage == "" || self.currentEnv?.errorMessage == nil {
                            self.skScene?.moveSpriteHorizontal(position: 0.0)
                            self.updateGameText()
                        } else {
                            self.skScene?.jump(completion: { (didJump) in
                                if didJump == true {
                                    DispatchQueue.main.async {
                                        self.wrongWayAlert()
                                    }
                                }
                            })
                        }
                    default:
                        return
                    }
                }
            } else {
                NSLog("Error logging in with \(result)")
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInSegue" {
            guard let signInVC = segue.destination as? SigninViewController else { return }
            signInVC.signInController = signInController
        }
    }
}
