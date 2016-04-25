//
//  mainMenuViewController.swift
//  Project20
//
//  Created by Dawson Seibold on 4/17/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit
import GameKit

class mainMenuViewController: UIViewController, GKGameCenterControllerDelegate {

    //Outlets
    @IBOutlet var taungtLabel: UILabel!
    @IBOutlet var gameCenterButtonOutlet: UIBarButtonItem!
    @IBOutlet var startGameButtonOutlet: UIButton!
    @IBOutlet var howToPlayButtonOutlet: UIButton!
    
    //Varuables
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var highscore = 0
        //To get the saved score
        if let savedScore: Int = NSUserDefaults.standardUserDefaults().objectForKey("HighestScore") as? Int {
            highscore = savedScore
        }
        if highscore == 0 {
         taungtLabel.text = "Good Luck!"
        }else {
        taungtLabel.text = "Can you beat your high score of \(highscore)?"
        }
            
        //Sign User In To Game Center
        authenticateLocalPlayer()
        
        startGameButtonOutlet.layer.cornerRadius = 76.5
        howToPlayButtonOutlet.layer.cornerRadius = 76.5
        startGameButtonOutlet.layer.borderColor = UIColor.blackColor().CGColor
        howToPlayButtonOutlet.layer.borderColor = UIColor.blackColor().CGColor
        startGameButtonOutlet.layer.borderWidth = 2
        howToPlayButtonOutlet.layer.borderWidth = 2
        
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor(red:0.239216, green:0.239216, blue:0.239216, alpha:1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        navigationController!.navigationBar.barStyle = UIBarStyle.Black
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   //MARK: Game Center Code
    
    //initiate gamecenter
    func authenticateLocalPlayer(){
        
        var localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.presentViewController(viewController!, animated: true, completion: nil)
            }
                
            else {
                print((GKLocalPlayer.localPlayer().authenticated))
                if GKLocalPlayer.localPlayer().authenticated == true {
                  self.gameCenterButtonOutlet.enabled = true
                }
            }
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


    //MARK: Actions
    @IBAction func gameCenterButton(sender: AnyObject) {
        showLeader()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    


}
