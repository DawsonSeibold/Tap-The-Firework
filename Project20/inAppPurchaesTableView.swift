//
//  inAppPurchaesTableView.swift
//  Project20
//
//  Created by Dawson Seibold on 4/19/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit
import StoreKit

class MasterViewController: UITableViewController {
    
    let showDetailSegueIdentifier = "showDetail"
    
    var products = [SKProduct]()
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == showDetailSegueIdentifier {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return false
            }
            
            let product = products[indexPath.row]
            
            return iapProducts.store.isProductPurchased(product.productIdentifier)
        }
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showDetailSegueIdentifier {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let product = products[indexPath.row]
            
           // if let name = resourceNameForProductIdentifier(product.productIdentifier),
            //    detailViewController = segue.destinationViewController as? DetailViewController {
            //    let image = UIImage(named: name)
            //    detailViewController.image = image
           // }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "In App Purchases"
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(MasterViewController.reload), forControlEvents: .ValueChanged)
        
        let restoreButton = UIBarButtonItem(title: "Restore",
                                            style: .Plain,
                                            target: self,
                                            action: #selector(MasterViewController.restoreTapped(_:)))
        navigationItem.rightBarButtonItem = restoreButton
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MasterViewController.handlePurchaseNotification(_:)),
                                                         name: IAPHelper.IAPHelperPurchaseNotification,
                                                         object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        reload()
    }
    
    func reload() {
        products = []
        
        tableView.reloadData()
        
        iapProducts.store.requestProducts{success, products in
            if success {
                self.products = products!
                
                self.tableView.reloadData()
            }
            
            self.refreshControl?.endRefreshing()
        }
    }
    
    func restoreTapped(sender: AnyObject) {
        iapProducts.store.restorePurchases()
    }
    
    func handlePurchaseNotification(notification: NSNotification) {
        guard let productID = notification.object as? String else { return }
        
        for (index, product) in products.enumerate() {
            guard product.productIdentifier == productID else { continue }
            
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Fade)
        }
    }
}

// MARK: - UITableViewDataSource

extension MasterViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ProductCell
        
        let product = products[indexPath.row]
        
        cell.product = product
        cell.buyButtonHandler = { product in
            iapProducts.store.buyProduct(product)
        }
        
        cell.backgroundColor = UIColor(red:0.192157, green:0.192157, blue:0.192157, alpha:1.0)
        
        return cell
    }
}

