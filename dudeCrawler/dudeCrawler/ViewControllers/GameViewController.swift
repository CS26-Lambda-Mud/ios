//
//  GameViewController.swift
//  dudeCrawler
//
//  Created by Jake Connerly on 3/3/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var skView1: SKView!
    @IBOutlet weak var scriptTextView: UITextView!
    @IBOutlet weak var northButton: UIButton!
    @IBOutlet weak var eastButton: UIButton!
    @IBOutlet weak var southButton: UIButton!
    @IBOutlet weak var westButton: UIButton!
    
    var skScene: CustomScene? = nil
    
    let myText = "Welcome To Dude Dungeon Crawler"
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scriptTextView.text = ""
        animateText(text: myText)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        skScene = CustomScene(size: view.bounds.size)
        skView1.presentScene(skScene)
    }
    
    private func animateText(text: String) {
        for char in text {
            scriptTextView.text! += "\(char)"
            RunLoop.current.run(until: Date() + 0.10)
        }
    }
    @IBAction func startGameTapped(_ sender: UIButton) {
    }
    
    @IBAction func northButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func eastButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func southButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func westButtonTapped(_ sender: Any) {
    }
}
