//
//  pauseScreenViewController.swift
//  Project20
//
//  Created by Dawson Seibold on 4/17/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit

class pauseScreenViewController: UIViewController {

    //Outlets
    @IBOutlet var resumeButtonOutlet: UIButton!
    @IBOutlet var quitButtonOutlet: UIButton!
    
    //Varuables
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        resumeButtonOutlet.layer.cornerRadius = 10
        quitButtonOutlet.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func resumeButton(sender: AnyObject) {
        // notify to resume Game!
        NSNotificationCenter.defaultCenter().postNotificationName("resumeGame", object: nil);
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func quitButton(sender: AnyObject) {
        // notify to quit game!
        NSNotificationCenter.defaultCenter().postNotificationName("quitGame", object: nil);
        self.dismissViewControllerAnimated(true, completion: nil)
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
