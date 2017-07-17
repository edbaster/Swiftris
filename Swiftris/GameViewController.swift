//
//  GameViewController.swift
//  Swiftris
//
//  Created by Eduardo Pacheco on 08/06/17.
//  Copyright © 2017 Eduardo Pacheco. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    // MARK: - Properties
    fileprivate var scene: GameScene!
    fileprivate var swiftris: Swiftris!
    fileprivate var panPointReference: CGPoint?

    // MARK: - Outlets
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!

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
        let currentPoint = sender.translation(in: view)
        if let originalPoint = panPointReference {
            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
                if sender.velocity(in: view).x > CGFloat(0) {
                    swiftris.moveShapeRight()
                    panPointReference = currentPoint
                } else {
                    swiftris.moveShapeLeft()
                    panPointReference = currentPoint
                }
            }
        } else if sender.state == .began {
            panPointReference = currentPoint
        }
    }

    @IBAction func didSwipe(_ sender: UISwipeGestureRecognizer) {
        swiftris.dropShape()
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
        levelLabel.text = "\(swiftris.level)"
        scoreLabel.text = "\(swiftris.score)"
        scene.tickLengthMilis = TickLengthLevelOne

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
        scene.playSound(sound: "Sounds/gameover.mp3")
        scene.animateCollapsingLines(linesToRemove: swiftris.removeAllBlocks(), fallenBlocks: swiftris.removeAllBlocks()) {
            swiftris.beginGame()
        }
    }

    func gameDidLevelUp(swiftris: Swiftris) {
        levelLabel.text = "\(swiftris.level)"
        if scene.tickLengthMilis >= 100 {
            scene.tickLengthMilis -= 100
        } else if scene.tickLengthMilis > 50 {
            scene.tickLengthMilis -= 50
        }
        scene.playSound(sound: "Sounds/levelup.mp3")
    }

    func gameShapeDidDrop(swiftris: Swiftris) {
        scene.stopTicking()
        scene.redrawShape(shape: swiftris.fallingShape!) {
            swiftris.letShapeFall()
        }
        scene.playSound(sound: "Sounds/drop.mp3")
    }

    func gameShapeDidLand(swiftris: Swiftris) {
        scene.stopTicking()
        view.isUserInteractionEnabled = false
        let removedLines = swiftris.removeCompletedLines()
        if removedLines.linesRemoved.count > 0 {
            scoreLabel.text = "\(swiftris.score)"
            scene.animateCollapsingLines(linesToRemove: removedLines.linesRemoved, fallenBlocks: removedLines.fallenBlocks) {
                self.gameShapeDidLand(swiftris: swiftris)
            }
            scene.playSound(sound: "Sounds/bomb.mp3")
        } else {
            nextShape()
        }
    }

    func gameShapeDidMove(swiftris: Swiftris) {
        scene.redrawShape(shape: swiftris.fallingShape!) {}
    }
}

// MARK: Gesture Recognizer Methods
extension GameViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer {
            if otherGestureRecognizer is UIPanGestureRecognizer {
                return true
            }
        } else if gestureRecognizer is UIPanGestureRecognizer {
            if otherGestureRecognizer is UITapGestureRecognizer {
                return true
            }
        }
        return false
    }
}



















