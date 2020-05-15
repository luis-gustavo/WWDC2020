//
//  GameViewController.swift
//  wwdc2020
//
//  Created by Luis Gustavo Avelino de Lima Jacinto on 08/05/20.
//  Copyright © 2020 Luis Gustavo Avelino de Lima Jacinto. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(startNewScene), name: .replay, object: nil)

        startNewScene()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .replay, object: nil)
    }

    @objc private func startNewScene() {
        guard let view = view as? SKView else {
            fatalError("View must be of type: \(type(of: SKView.self))")
        }
        let gameScene = GameScene(size: view.bounds.size)
        view.presentScene(gameScene)
        view.ignoresSiblingOrder = true
//        view.showsFPS = true
//        view.showsNodeCount = true
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
