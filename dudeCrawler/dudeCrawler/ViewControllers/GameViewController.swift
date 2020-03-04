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
    var currentEnv: Enviornment? {
        didSet {
            scriptTextView.text = ""
            updateGameText()
        }
    }
    
    let gameController = GameController()
    
    // MARK: - View LifeCycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scriptTextView.text = ""
        animateText(text: myText)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        skScene = CustomScene(size: view.bounds.size)
        skView1.presentScene(skScene)
        if accessKey == nil {
            performSegue(withIdentifier: "SignInSegue", sender: self)
        }
    }
    
    // MARK: - IBActions & Methods
    
    private func animateText(text: String) {
        for char in text {
            scriptTextView.text! += "\(char)"
            RunLoop.current.run(until: Date() + 0.05)
        }
    }
    
    private func updateGameText() {
        var gameText = ""
        guard let currentEnv = currentEnv else { return }
        if currentEnv.title == "Outside Cave Entrance" {
            gameText = "Welcome \(currentEnv.name)! You are currently \(currentEnv.title) and \(currentEnv.description)..."
        } else {
            gameText = "\(currentEnv.name), you are currently in a \(currentEnv.title) and \(currentEnv.description).\n\n Which way will you go?"
        }
        animateText(text: gameText)
    }
    
    @IBAction func startGameTapped(_ sender: UIButton) {
        guard let accessKey = accessKey else { return }
        gameController.startGameWith(token: accessKey) { (result) in
            if (try? result.get()) != nil {
                DispatchQueue.main.async {
                    self.currentEnv = self.gameController.enviornment
                    
                }
            } else {
                NSLog("Error logging in with \(result)")
            }
        }
    }
    
    @IBAction func moveButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            moveDirection = MoveDirection(direction: Directions.n.rawValue)
        case 1:
            moveDirection = MoveDirection(direction: Directions.e.rawValue)
        case 2:
            moveDirection = MoveDirection(direction: Directions.s.rawValue)
        case 3:
            moveDirection = MoveDirection(direction: Directions.w.rawValue)
        default:
            return
        }
        guard let accessKey = accessKey,
            let moveDir = moveDirection else { return }
        gameController.move(direction: moveDir, token: accessKey) { (result) in
            if (try? result.get()) != nil {
                DispatchQueue.main.async {
                    self.currentEnv = self.gameController.enviornment
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
