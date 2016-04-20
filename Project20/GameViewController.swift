//
//  GameViewController.swift
//  Project20
//
//  Created by Hudzilla on 16/09/2015.
//  Copyright (c) 2015 Paul Hudson. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import iAd

class GameViewController: UIViewController, GKGameCenterControllerDelegate, ADBannerViewDelegate, GameSceneDelegate {

    //Outlets
    @IBOutlet var gameOverView: UIView!
    @IBOutlet var highScoreLabel: UILabel!
    @IBOutlet var usersScoreLabel: UILabel!
    @IBOutlet var adBanner: ADBannerView!
    
    @IBOutlet var leaderBoardButtonOutlet: UIButton!
    @IBOutlet var restartButtonOutlet: UIButton!
    @IBOutlet var mainMenuButtonOutlet: UIButton!
    
    //Varuables
    let testScene = GameScene(fileNamed: "GameScene")

    
    override func viewDidLoad() {
        super.viewDidLoad()

       // if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            testScene!.scaleMode = .AspectFill
            
            testScene!.viewDelegate = self
            skView.presentScene(testScene)
      //  }
        
        var allowAds = Bool()
        //To get the saved score
        if let newAllowedAds: Bool = NSUserDefaults.standardUserDefaults().boolForKey("allowAds"){
            allowAds = newAllowedAds
        }
        if allowAds == false {
            self.canDisplayBannerAds = true
            self.adBanner.delegate = self
            self.adBanner.hidden = true
        }else {
            self.adBanner.hidden = true
        }

        }
    
    

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

	override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
		let skView = view as! SKView
		let gameScene = skView.scene as! GameScene
		gameScene.explodeFireworks()
	}
    
    func gameOverViewController(scene: SKScene) {
        //var mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //var vc = mainStoryboard.instantiateViewControllerWithIdentifier("1") as! UIViewController
        //presentViewController(vc, animated: true, completion: nil)
        //show View Controller
        self.adBanner.hidden = false
        
        let score = testScene?.score
        
        usersScoreLabel.text = "\(score!)"
        
        var highscore = 0
        //To get the saved score
        if let savedScore: Int = NSUserDefaults.standardUserDefaults().objectForKey("HighestScore") as? Int {
            highscore = savedScore
        }
        
        highScoreLabel.text = "\(highscore)"
        gameOverView.hidden = false
        
        

        // note that you don't need to go through a bunch of optionals to call presentViewController
    }

    
    func showPopover() {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("pausedScreen")
        controller.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        let popoverPresentationController = controller.popoverPresentationController
        //popoverPresentationController?.delegate = self
        // result is an optional (but should not be nil if modalPresentationStyle is popover)
        if let _popoverPresentationController = popoverPresentationController {
            
            // set the view from which to pop up
            _popoverPresentationController.sourceView = self.view;
            _popoverPresentationController.sourceRect = CGRectMake((view!.bounds.maxX/2)-150, (view!.bounds.maxY/2)-75, 300,150)
            _popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0);
            //_popoverPresentationController.delegate = self
            // present (id iPhone it is a modal automatic full screen)
            //300 X 150
            self.presentViewController(controller, animated: true, completion: nil)
            
            // ready for receiving notification
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "resumeTheGame:", name: "resumeGame", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "quitTheGame:", name: "quitGame", object: nil)
        }
    }
    
    func resumeTheGame(notification: NSNotification) {
        testScene?.countDownTimer.invalidate()
        testScene?.gameTimer.invalidate()
        testScene?.times = 1
        testScene?.countDownLabel.text = "2"
        testScene?.startGame()
        print("resumeTheGame")
    }
    
    func quitTheGame(notification: NSNotification) {
        testScene?.gameOver()
    }
    

    
    
    //MARK: Actions
    @IBAction func leaderBoardButton(sender: AnyObject) {
        showLeader()
    }
    @IBAction func restartButton(sender: AnyObject) {
        
        adBanner.hidden = true
        gameOverView.hidden = true
        testScene?.score = 0
        testScene?.createUI()
        testScene?.startGame()
        
    }
    @IBAction func mainMenuButton(sender: AnyObject) {
    }
    
    
    //MARK: Game Center Code
    
    //send high score to leaderboard
    func saveHighscore(score:Int) {
        
        //check if user is signed in
        if GKLocalPlayer.localPlayer().authenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: "tapTheFirework") //leaderboard id here
            
            scoreReporter.value = Int64(score) //score variable here (same as above)
            
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError?) -> Void in
                if error != nil {
                    print("error")
                }
            })
        }
        
    }
    
    //shows leaderboard screen
    func showLeader() {
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        self.presentViewController(gc, animated: true, completion: nil)
    }
    
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    
    //MARK: Ad Code
    
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        print("bannerViewWillLoadAd")
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        print("bannerViewDidLoadAd")
        //self.adBanner.hidden = false //now show banner as ad is loaded
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        print("bannerViewDidLoadAd")
        
        //optional resume paused game code
        
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        print("bannerViewActionShouldBegin")
        
        //optional pause game code
        
        return true
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        print("bannerView")
    }

    
}
