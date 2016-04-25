//
//  utilitys.swift
//  Final Jelly App
//
//  Created by Dawson Seibold on 2/22/16.
//  Copyright © 2016 Smile Development. All rights reserved.
//

import Foundation
import UIKit

func localNotification(message: NSString, currentView: UIView) {
    var notifyFrame:CGRect?
    var notifyView:SFSwiftNotification?
    
    //Add Local Notification Thing
    notifyFrame = CGRectMake(0, 0, CGRectGetMaxX(currentView.frame), 50)
    notifyView = SFSwiftNotification(frame: notifyFrame!,title: nil,animationType: AnimationType.AnimationTypeCollision,direction: Direction.RightToLeft)
    notifyView!.backgroundColor = UIColor(red:0.000000, green:0.764706, blue:0.235294, alpha:1.0)
    notifyView!.label.textColor = UIColor.whiteColor()
    notifyView!.label.text = "\(message)"
    currentView.addSubview(notifyView!)
    
    notifyView!.animate(notifyFrame!, delay: 1)
}





//MARK: Delay

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

//To Call
//delay(0.4) {
    // do stuff
//}



//MARK: UIAlert
func showBasicAlert(title: String, message: String, buttonTitle: String) {
    var alert = UIAlertView()
    alert.title = "\(title)"
    alert.message = "\(message)"
    alert.addButtonWithTitle("\(buttonTitle)")
    alert.show()
}




//MARK: Use Youtube API

//TODO: Add Youtube API Here



