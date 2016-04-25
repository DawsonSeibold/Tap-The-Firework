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
    var firework2Array = [SKNode]()
    var emitterArray = [SKEmitterNode]()
    var highscore = 0
    var cleaningUp = false
    
    //UI Elements
    var scoreLabel = UILabel()
    let pauseButton = UIButton()
    var countDownLabel = UILabel()
    var explodeButton = UIButton()
    var background = SKSpriteNode()
    var testBox = UIView()
    var highScoreLabel = UILabel()
    
    var viewDelegate: GameSceneDelegate?
    var numOfRocketsOffScreen = 6
    var canLoose = false
    
    var remainingRocketsLabel = UILabel()
    
    //Arrays
    var fireworkArray = [SKNode]()

	let leftEdge = -22
	let bottomEdge = -22
	let rightEdge = 1024 + 22

	var score: Int = 0 {
		didSet {
			// your code here
            scoreLabel.text = "Score: \(score)"
            
            if canLoose == true && score < 0 {
                gameOver()
            }
            
            if numOfRocketsOffScreen <= 0 {
                gameOver()
            }
            
		}
	}

	override func didMoveToView(view: SKView) {
        
        createUI()

		startGame()
        
        
        //To get the saved score
        if let savedScore: Int = NSUserDefaults.standardUserDefaults().objectForKey("HighestScore") as? Int {
            highscore = savedScore
        }
	}
    
    func startGame() {
        print("Starting Game")
        cleaningUp = false
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
        if cleaningUp == false {
		for (index, firework) in fireworks.enumerate().reverse() {
			if firework.position.y > 900 {
				// this uses a position high above so that rockets can explode off screen
				let emitterNode = emitterArray[index] 
                let fireworkNode = firework2Array[index]
                emitterNode.removeFromParent()
                emitterArray.removeAtIndex(index)
                fireworkNode.removeFromParent()
                firework2Array.removeAtIndex(index)
                
                fireworks.removeAtIndex(index)
                firework.removeFromParent()
                numOfRocketsOffScreen -= 1
                if numOfRocketsOffScreen == 0 {
                    //Game Over
                    gameOver()
                }
                remainingRocketsLabel.text = "Rockets: \(numOfRocketsOffScreen)"
                if canLoose == true {
                    score -= 75
                }
                print("deleating fireworks, number of fireworks: \(fireworks.count)")
			}
            }
            
            //Test if score is grater then high score
            if score > highscore {
                highScoreLabel.hidden = false
            }

		}
        /*
        self.enumerateChildNodesWithName("justCreated", usingBlock: {
            node, stop in
 
            if node.position.x > 50 && node.position.x < ((self.view?.frame.maxX)!-100) {
                if node.position.y > 50 && node.position.y < ((self.view?.frame.maxY)!-100) {
                    node.name = "onTheScreen"
                    print("justCreated")
                }
            }
        })
        
        self.enumerateChildNodesWithName("onTheScreen", usingBlock: {
            node, stop in
            
            if node.position.x + node.frame.width/2 < 0 || node.position.x - node.frame.width/2 > self.size.width || node.position.y + node.frame.height/2 <= 0 || node.position.y - node.frame.height/2 >= self.size.height {
                node.name = "BeenTested"
                print("Firework Off the screen")
                
                //Check if all 5 are still on the screen
                if self.fireworks.count >= 9 {
                    print("You Lost")
                }
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
 */
        
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
        //background = SKSpriteNode(imageNamed:  "skyBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        background.zPosition = -1
        addChild(background)
        
        //Add pause button
        pauseButton.frame = CGRectMake(((view?.frame.maxX)! - 60), 2, 50, 50)
        pauseButton.backgroundColor = UIColor.redColor()
        pauseButton.layer.cornerRadius = 15
        pauseButton.setBackgroundImage(UIImage(named: "pauseButtonImage"), forState: UIControlState.Normal)
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
        explodeButton.setBackgroundImage(UIImage(named: "explosion"), forState: UIControlState.Normal)
        explodeButton.layer.cornerRadius = 10
        explodeButton.addTarget(self, action: "explodeFireworks", forControlEvents: .TouchUpInside)
        view?.addSubview(explodeButton)
        
        //Test View
        testBox.frame = CGRectMake(50, 50, (view?.frame.width)! - 100, (view?.frame.height)! - 100)
        testBox.layer.borderColor = UIColor.purpleColor().CGColor
        testBox.layer.borderWidth = 2
        //view?.addSubview(testBox)
        
        // Remaning Rockets that can go off the screen Label
        remainingRocketsLabel.frame = CGRectMake(130, (view?.frame.maxY)! - 30, 120, 28)
        remainingRocketsLabel.textColor = UIColor.whiteColor()
        //countDownLabel.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.7)
        remainingRocketsLabel.text = "Rockets: 6"
        remainingRocketsLabel.layer.cornerRadius = 50
        remainingRocketsLabel.textAlignment = .Center
        view?.addSubview(remainingRocketsLabel)
        
        //New High Score Label
        highScoreLabel.frame = CGRectMake(5,5,210,30)
        highScoreLabel.textColor = UIColor.redColor()
        highScoreLabel.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.7)
        highScoreLabel.text = "New High Score!"
        highScoreLabel.layer.cornerRadius = 10
        highScoreLabel.textAlignment = .Center
        highScoreLabel.font = UIFont(name: (countDownLabel.font?.fontName)! , size: 26)
        highScoreLabel.hidden = true
        view?.addSubview(highScoreLabel)
    
        
    }

    func createFirework(xMovement xMovement: CGFloat, x: Int, y: Int, followNodeName: String, direction: String) {
		
        //let followNode = SKNode()
        //followNode.position = CGPoint(x: x, y: y)
        //followNode.name = "\(followNodeName)"
        
        // 1
		let node = SKNode()
		node.position = CGPoint(x: x, y: y)
        node.name = "justCreated"

		// 2
		//let firework = SKSpriteNode(imageNamed: "rocket")
        let firework = SKSpriteNode(imageNamed: "firework")
		firework.name = "firework"
        firework2Array.append(firework)
		node.addChild(firework)
        
        //let firework = SKSpriteNode(imageNamed: "firework")
        //firework.position = CGPoint(x: x, y: y)
        //firework.name = "firework"
        

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
        //firework.runAction(move)
        //followNode.runAction(move)

		// 6
		let emitter = SKEmitterNode(fileNamed: "fuse")!
		emitter.position = CGPoint(x: 0, y: -22)
        emitterArray.append(emitter)
		node.addChild(emitter)
        //firework.addChild(emitter)

		// 7
		fireworks.append(node)
        //fireworks.append(firework)
		addChild(node)
        //addChild(firework)
        
        //fireworkArray.append(followNode)
	}

	func launchFireworks() {
		let movementAmount: CGFloat = 1800

		switch GKRandomSource.sharedRandom().nextIntWithUpperBound(4) {
		case 0:
			// fire five, straight up
			createFirework(xMovement: 0, x: 512, y: bottomEdge, followNodeName: "s1", direction: "up")
			createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge, followNodeName: "s2", direction: "up")
			createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge, followNodeName: "s3", direction: "up")
			createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge, followNodeName: "s4", direction: "up")
			createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge, followNodeName: "s5", direction: "up")

		case 1:
			// fire five, in a fan
			createFirework(xMovement: 0, x: 512, y: bottomEdge, followNodeName: "f1", direction: "up")
			createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge, followNodeName: "f2", direction: "up")
			createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge, followNodeName: "f3", direction: "up")
			createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge, followNodeName: "f4", direction: "up")
			createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge, followNodeName: "f5", direction: "up")

		case 2:
			// fire five, from the left to the right
			createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400, followNodeName: "l1", direction: "left")
			createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300, followNodeName: "l2", direction: "left")
			createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200, followNodeName: "l3", direction: "left")
			createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100, followNodeName: "l4", direction: "left")
			createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge, followNodeName: "l5", direction: "left")

		case 3:
			// fire five, from the right to the left
			createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400, followNodeName: "r1", direction: "right")
			createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300, followNodeName: "r2", direction: "right")
			createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200, followNodeName: "r3", direction: "right")
			createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100, followNodeName: "r4", direction: "right")
			createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge, followNodeName: "r5", direction: "right")

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
                     //   let firework = parent as! SKSpriteNode
                    //let firework = sprite

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

    func explodeFirework(firework: SKNode, index: Int) {
		let emitter = SKEmitterNode(fileNamed: "explode")!
		emitter.position = firework.position
        emitter.name = "explodingNode"
		addChild(emitter)

        let emitterNode = emitterArray[index]
        let fireworkNode = firework2Array[index]
        emitterNode.removeFromParent()
        emitterArray.removeAtIndex(index)
        fireworkNode.removeFromParent()
        firework2Array.removeAtIndex(index)
        
		firework.removeFromParent()
        
        delay(0.6, closure: {
            emitter.removeFromParent()
        })
	}

	func explodeFireworks() {
        canLoose = true
		var numExploded = 0

		for (index, fireworkGroup) in fireworks.enumerate().reverse() {
			 let firework = fireworkGroup.children[0] as! SKSpriteNode
            //let firework = fireworkGroup as! SKSpriteNode

			if firework.name == "selected" {
				// destroy this firework!
				explodeFirework(fireworkGroup, index: index)
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
        cleaningUp = true
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
        highScoreLabel.hidden = true
        remainingRocketsLabel.hidden = true
        
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
        
        testBox.hidden = true
        highScoreLabel.hidden = true
        remainingRocketsLabel.hidden = true
        
        viewDelegate?.showPopover()

    }
    
    

    
}
