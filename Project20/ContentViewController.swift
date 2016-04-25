//
//  ContentViewController.swift
//  Project20
//
//  Created by Dawson Seibold on 4/23/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    //Outlets
    @IBOutlet var imageView: UIImageView!
    
    //Varuables
    var pageIndex: Int!
    var imageFile: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = UIImage(named: self.imageFile)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
