//
//  GameViewController.swift
//  Swiftris
//
//  Created by Eduardo Pacheco on 08/06/17.
//  Copyright © 2017 Eduardo Pacheco. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - Properties
    fileprivate var scene: GameScene!
    fileprivate var swiftris: Swiftris!
    fileprivate var panPointReference: CGPoint?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the view.
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false

        // Configure the scene
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        scene.tick = didTick
        swiftris = Swiftris()
        swiftris.delegate = self
        swiftris.beginGame()

        skView.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Actions
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        swiftris.rotateShape()
    }

    @IBAction func didPan(sender: UIPanGestureRecognizer) {

    }

    // MARK: - Private Methods
    private func didTick() {
        swiftris.letShapeFall()
    }

    fileprivate func nextShape() {
        let newShapes = swiftris.newShape()
        guard let fallingShape = newShapes.fallingShape else { return }
        self.scene.addPreviewShapeToScene(shape: newShapes.nextShape!) {}
        self.scene.movePreviewShape(shape: fallingShape) {
            self.view.isUserInteractionEnabled = true
            self.scene.startTicking()
        }
    }
}

// MARK: - Swiftris Delegate Methods
extension GameViewController: SwiftrisDelegate {

    func gameDidBegin(swiftris: Swiftris) {
        // The following is false when restarting a new game
        if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(shape: swiftris.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }

    func gameDidEnd(swiftris: Swiftris) {
        view.isUserInteractionEnabled = false
        scene.stopTicking()
    }

    func gameDidLevelUp(swiftris: Swiftris) {

    }

    func gameShapeDidDrop(swiftris: Swiftris) {

    }

    func gameShapeDidLand(swiftris: Swiftris) {
        scene.stopTicking()
        nextShape()
    }

    func gameShapeDidMove(swiftris: Swiftris) {
        scene.redrawShape(shape: swiftris.fallingShape!) {}
    }
}
