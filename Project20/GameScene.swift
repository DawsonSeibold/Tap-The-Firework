//
//  GameScene.swift
//  Project20
//
//  Created by Hudzilla on 16/09/2015.
//  Copyright (c) 2015 Paul Hudson. All rights reserved.
//

import GameplayKit
import SpriteKit


protocol GameSceneDelegate {
    
    func gameOverViewController(scene: SKScene)
    
    func showPopover()
    
    func saveHighscore(score:Int)
}

class GameScene: SKScene {
	var gameTimer: NSTimer!
    var countDownTimer: NSTimer!
	var fireworks = [SKNode]()
    var scoreLabel = UILabel()
    let pauseButton = UIButton()
    var countDownLabel = UILabel()
    var explodeButton = UIButton()
    var background = SKSpriteNode()
    var testBox = UIView()
    var viewDelegate: GameSceneDelegate?

	let leftEdge = -22
	let bottomEdge = -22
	let rightEdge = 1024 + 22

	var score: Int = 0 {
		didSet {
			// your code here
            scoreLabel.text = "Score: \(score)"
		}
	}

	override func didMoveToView(view: SKView) {
        
        createUI()

		startGame()
        
        print("X: \(((self.view?.frame.maxX)!-100)), Y: \(((self.view?.frame.maxY)!-100))")
	}
    
    func startGame() {
        print("Starting Game")
        countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "displayCount", userInfo: nil, repeats: true)
    }
    var times = 0
    func displayCount() {
        if times >= 3 {
            countDownLabel.hidden = true
            startGameTimer()
            countDownTimer.invalidate()
            pauseButton.enabled = true
            times = 0
        }else {
            times += 1
            if times == 1 {
                countDownLabel.hidden = false
                countDownLabel.text = "3"
            }else if times == 2 {
                countDownLabel.hidden = false
                countDownLabel.text = "2"
            }else if times == 3 {
                countDownLabel.hidden = false
                countDownLabel.text = "1"
            }
        }
    }
    
    func startGameTimer() {
        launchFireworks()
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: "launchFireworks", userInfo: nil, repeats: true)
    }
   
	override func update(currentTime: NSTimeInterval) {
		for (index, firework) in fireworks.enumerate().reverse() {
			if firework.position.y > 900 {
				// this uses a position high above so that rockets can explode off screen
				fireworks.removeAtIndex(index)
				firework.removeFromParent()
                    print("deleating fireworks, number of fireworks: \(fireworks.count)")
			}
            if firework.position.y < -15 {
                if fireworks.count <= 5 {
                    //print("You Lose!, number of fireworks: \(fireworks.count)")
                }
            }
		}
        
        self.enumerateChildNodesWithName("justCreated", usingBlock: {
            node, stop in
            
            
            if node.position.x > 50 && node.position.x < ((self.view?.frame.maxX)!-100) {
                if node.position.y < 50 && node.position.y > ((self.view?.frame.maxY)!-100) {
                    node.name = "onTheScreen"
                    print("Good, X: \(node.position.x), Y: \(node.position.y)")
                }
            }
            if node.position.x > 50 || node.position.x < ((self.view?.frame.maxX)!-100) || node.position.y < 50 || node.position.y > ((self.view?.frame.maxY)!-100){
                
            }
            
            if (self.intersectsNode(node)) {
                //node.name = "onTheScreen"
                //print("a")
            }
            
            if node.position.x - node.frame.width/2 < 0 || node.position.x + node.frame.width/2 > self.size.width || node.position.y - node.frame.height/2 < 0 || node.position.y + node.frame.height/2 > self.size.height {
               // node.name = "onTheScreen"
               // print("t")
            }
            
        })
        
        self.enumerateChildNodesWithName("onTheScreen", usingBlock: {
            node, stop in
            
            if node.position.x + node.frame.width/2 < 0 || node.position.x - node.frame.width/2 > self.size.width || node.position.y + node.frame.height/2 < 0 || node.position.y - node.frame.height/2 > self.size.height {
                node.name = "BeenTested"
                print("Firework Off the screen")
            }
            
        })
        
        if fireworks.count >= 8 {
            if (!intersectsNode(fireworks[0])) {
                //Not on the screen
                if fireworks.count >= 8 {
                //You lose
                //print("YOU LOSE!, \(fireworks.count), firework 0")
                }
            }else if (!intersectsNode(fireworks[1])) {
                //Not on the screen
                if fireworks.count >= 8 {
                    //You lose
                 //   print("YOU LOSE!, \(fireworks.count), firework 1")
                }
            }else if (!intersectsNode(fireworks[2])) {
                //Not on the screen
                if fireworks.count >= 8 {
                    //You lose
                 //   print("YOU LOSE!, \(fireworks.count), firework 2")
                }
            }else if (!intersectsNode(fireworks[3])) {
                //Not on the screen
                if fireworks.count >= 8 {
                    //You lose
                  //  print("YOU LOSE!, \(fireworks.count), firework 3")
                }
            }else if (!intersectsNode(fireworks[4])) {
                //Not on the screen
                if fireworks.count >= 8 {
                    //You lose
                  //  print("YOU LOSE!, \(fireworks.count), firework 4")
                }
            }else {
               // print("All were distroyed")
            }
        }
        
        /*
        if fireworks.isEmpty == false {
            if fireworks[0].position.y < -100 {
                print("TOP")
                if fireworks.count >= 8 {
                    print("theTop, \(fireworks.count)")
                }
            }
            if fireworks[0].position.x < -100 || fireworks[1].position.x < -100 || fireworks[2].position.x < -100 || fireworks[3].position.x < -100 {//|| fireworks[4].position.x < -100{
                print("LEFT")
                if fireworks.count >= 8 {
                    print("<-, \(fireworks.count)")
                }
            }
            if fireworks[0].position.x > ((view?.frame.maxX)! + 100) {
                print("Right")
                if fireworks.count >= 8 {
                    print("->, \(fireworks.count)")
                }
            }
        }
 */
	}
    
    func createUI() {
        //Background
        background.removeFromParent()
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        background.zPosition = -1
        addChild(background)
        
        //Add button
        pauseButton.frame = CGRectMake(((view?.frame.maxX)! - 60), 2, 50, 50)
        pauseButton.backgroundColor = UIColor.redColor()
        pauseButton.layer.cornerRadius = 15
        //TODO: Add Pause Image to Button
        //pauseButton.addTarget(self, action: "gameOver", forControlEvents: .TouchUpInside)
        pauseButton.addTarget(self, action: "pauseGame", forControlEvents: .TouchUpInside)
        pauseButton.enabled = false
        view?.addSubview(pauseButton)
        
        //Add Score label
        scoreLabel.frame = CGRectMake(5, (view?.frame.maxY)! - 30, 120, 28)
        scoreLabel.text = "Score: \(score)"
        scoreLabel.textColor = UIColor.whiteColor()
        scoreLabel.backgroundColor = UIColor.purpleColor()
        scoreLabel.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.4)
        scoreLabel.layer.cornerRadius = 50
        scoreLabel.textAlignment = .Center
        view?.addSubview(scoreLabel)
        
        //Count down Label
        countDownLabel.frame = CGRectMake(((view?.frame.maxX)!/2) - 100 , ((view?.frame.maxY)!/2) - 100 , 200, 200)
        countDownLabel.textColor = UIColor.whiteColor()
        //countDownLabel.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.7)
        countDownLabel.text = "3"
        countDownLabel.layer.cornerRadius = 50
        countDownLabel.textAlignment = .Center
        countDownLabel.font = UIFont(name: (countDownLabel.font?.fontName)! , size: 50)
        view?.addSubview(countDownLabel)
        
        //Explode Button
        explodeButton.frame = CGRectMake(((view?.frame.maxX)! - 80), ((view?.frame.maxY)! - 90), 70, 70)
        explodeButton.backgroundColor = UIColor.blueColor()
        explodeButton.layer.cornerRadius = 10
        explodeButton.addTarget(self, action: "explodeFireworks", forControlEvents: .TouchUpInside)
        view?.addSubview(explodeButton)
        
        //Test View
        testBox.frame = CGRectMake(50, 50, (view?.frame.width)! - 100, (view?.frame.height)! - 100)
        testBox.layer.borderColor = UIColor.purpleColor().CGColor
        testBox.layer.borderWidth = 2
        view?.addSubview(testBox)
    
        
    }

	func createFirework(xMovement xMovement: CGFloat, x: Int, y: Int) {
		// 1
		let node = SKNode()
		node.position = CGPoint(x: x, y: y)
        node.name = "justCreated"

		// 2
		let firework = SKSpriteNode(imageNamed: "rocket")
		firework.name = "firework"
		node.addChild(firework)

		// 3
		switch GKRandomSource.sharedRandom().nextIntWithUpperBound(3) {
		case 0:
			firework.color = UIColor.cyanColor()
			firework.colorBlendFactor = 1

		case 1:
			firework.color = UIColor.greenColor()
			firework.colorBlendFactor = 1

		case 2:
			firework.color = UIColor.redColor()
			firework.colorBlendFactor = 1

		default:
			break
		}

		// 4
		let path = UIBezierPath()
		path.moveToPoint(CGPoint(x: 0, y: 0))
		path.addLineToPoint(CGPoint(x: xMovement, y: 1000))

		// 5
		let move = SKAction.followPath(path.CGPath, asOffset: true, orientToPath: true, speed: 200)
		node.runAction(move)

		// 6
		let emitter = SKEmitterNode(fileNamed: "fuse")!
		emitter.position = CGPoint(x: 0, y: -22)
		node.addChild(emitter)

		// 7
		fireworks.append(node)
		addChild(node)
	}

	func launchFireworks() {
		let movementAmount: CGFloat = 1800

		switch GKRandomSource.sharedRandom().nextIntWithUpperBound(4) {
		case 0:
			// fire five, straight up
			createFirework(xMovement: 0, x: 512, y: bottomEdge)
			createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
			createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
			createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
			createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)

		case 1:
			// fire five, in a fan
			createFirework(xMovement: 0, x: 512, y: bottomEdge)
			createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
			createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
			createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
			createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)

		case 2:
			// fire five, from the left to the right
			createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
			createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
			createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
			createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
			createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)

		case 3:
			// fire five, from the right to the left
			createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
			createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
			createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
			createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
			createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)

		default:
			break
		}
	}

	func checkForTouches(touches: Set<UITouch>) {
		guard let touch = touches.first else { return }

		let location = touch.locationInNode(self)
		let nodes = nodesAtPoint(location)
        
		for node in nodes {
			if node.isKindOfClass(SKSpriteNode.self) {
				let sprite = node as! SKSpriteNode

				if sprite.name == "firework" {
					for parent in fireworks {
						let firework = parent.children[0] as! SKSpriteNode

						if firework.name == "selected" && firework.color != sprite.color {
							firework.name = "firework"
							firework.colorBlendFactor = 1
						}
					}

					sprite.name = "selected"
					sprite.colorBlendFactor = 0
				}
			}
		}
	}

	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)
		checkForTouches(touches)
	}

	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesMoved(touches, withEvent: event)
		checkForTouches(touches)
	}

	func explodeFirework(firework: SKNode) {
		let emitter = SKEmitterNode(fileNamed: "explode")!
		emitter.position = firework.position
        emitter.name = "explodingNode"
		addChild(emitter)

		firework.removeFromParent()
	}

	func explodeFireworks() {
		var numExploded = 0

		for (index, fireworkGroup) in fireworks.enumerate().reverse() {
			let firework = fireworkGroup.children[0] as! SKSpriteNode

			if firework.name == "selected" {
				// destroy this firework!
				explodeFirework(fireworkGroup)
				fireworks.removeAtIndex(index)

				numExploded += 1
			}
		}

		switch numExploded {
		case 0:
			// nothing – rubbish!
			break
		case 1:
			score += 50 //Old 200
		case 2:
			score += 100 //500
		case 3:
			score += 150 //1500
		case 4:
			score += 250 //2500
		default:
			score += 400  //4000
		}
	}
    
    
    
    func gameOver() {
        gameTimer.invalidate()
        for (index, firework) in fireworks.enumerate().reverse() {
                fireworks.removeAtIndex(index)
                firework.removeFromParent()
                print("deleating all fireworks, number of fireworks: \(fireworks.count)")
        }
        self.enumerateChildNodesWithName("selected") {
            node, stop in
            // Do something with node.
            node.removeFromParent()
        }
        self.enumerateChildNodesWithName("explodingNode") {
            node, stop in
            // Do something with node.
            node.removeFromParent()
        }
        countDownLabel.removeFromSuperview()
        pauseButton.removeFromSuperview()
        scoreLabel.removeFromSuperview()
        explodeButton.removeFromSuperview()
        var highscore = 0
        //To get the saved score
        if let savedScore: Int = NSUserDefaults.standardUserDefaults().objectForKey("HighestScore") as? Int {
            highscore = savedScore
        }
        
        //Test if score is grater then high score
        if score > highscore {
        //To save highest score
        NSUserDefaults.standardUserDefaults().setObject(score, forKey:"HighestScore")
        NSUserDefaults.standardUserDefaults().synchronize()
            
            //Send to game center
            viewDelegate?.saveHighscore(score)
        }
        viewDelegate?.gameOverViewController(self)
    }
    
    func pauseGame() {
        gameTimer.invalidate()
        for (index, firework) in fireworks.enumerate().reverse() {
            fireworks.removeAtIndex(index)
            firework.removeFromParent()
            print("deleating all fireworks, number of fireworks: \(fireworks.count)")
        }
        self.enumerateChildNodesWithName("selected") {
            node, stop in
            // Do something with node.
            node.removeFromParent()
        }
        self.enumerateChildNodesWithName("explodingNode") {
            node, stop in
            // Do something with node.
            node.removeFromParent()
        }
        
        var highscore = 0
        //To get the saved score
        if let savedScore: Int = NSUserDefaults.standardUserDefaults().objectForKey("HighestScore") as? Int {
            highscore = savedScore
        }
        
        //Test if score is grater then high score
        if score > highscore {
            //To save highest score
            NSUserDefaults.standardUserDefaults().setObject(score, forKey:"HighestScore")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            //Send to game center
            viewDelegate?.saveHighscore(score)
        }
        
        viewDelegate?.showPopover()

    }
    
    

    
}
