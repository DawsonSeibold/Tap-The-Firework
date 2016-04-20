//
//  inAppPurchasViewController.swift
//  Project20
//
//  Created by Dawson Seibold on 4/17/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit
import iAd
import StoreKit

class inAppPurchasViewController: UIViewController, ADBannerViewDelegate {

    //Outlet
    @IBOutlet var removeAdsButtonOutlet: UIButton!
    @IBOutlet var getInfoButtonOutlet: UIButton!
    @IBOutlet var restorePurchasesButtonOutlet: UIButton!
    @IBOutlet var adBanner: ADBannerView!
    
    //Varuable
    var products = [SKProduct]()
    
    let Prefix = "tapTheFierwork."
    let productId = "tapTheFierwork.removeAds"
    //let GirlfriendOfDrummerRage = Prefix + productId
    //let productIdentifiers: Set<ProductIdentifier> = [inAppPurchasViewController.GirlfriendOfDrummerRage]
    //let store = IAPHelper(productIds: inAppPurchasViewController.productIdentifiers)


    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        var allowAds = Bool()
        //To get the saved score
        if let newAllowedAds: Bool = NSUserDefaults.standardUserDefaults().boolForKey("allowAds"){
            allowAds = newAllowedAds
        }
        if allowAds == false {
            self.canDisplayBannerAds = true
            self.adBanner.delegate = self
            self.adBanner.hidden = true //hide until ad loaded
        }else {
            self.adBanner.hidden = true
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: Actions
    
    @IBAction func removeAds(sender: AnyObject) {
    }
    @IBAction func getInfoButton(sender: AnyObject) {
    }
    @IBAction func restorePurchasesButton(sender: AnyObject) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Ad Code
    
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        print("bannerViewWillLoadAd")
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        print("bannerViewDidLoadAd")
        self.adBanner.hidden = false //now show banner as ad is loaded
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
