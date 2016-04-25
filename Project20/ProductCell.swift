//
//  ProductCell.swift
//  Project20
//
//  Created by Dawson Seibold on 4/19/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit
import StoreKit

class ProductCell: UITableViewCell {
    //Outlets
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceOutlet: UILabel!
    
    static let priceFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        
        formatter.formatterBehavior = .Behavior10_4
        formatter.numberStyle = .CurrencyStyle
        
        return formatter
    }()
    
    var buyButtonHandler: ((product: SKProduct) -> ())?
    
    var product: SKProduct? {
        didSet {
            guard let product = product else { return }
            
            titleLabel?.text = product.localizedTitle
            
            if iapProducts.store.isProductPurchased(product.productIdentifier) {
                accessoryType = .Checkmark
                accessoryView = nil
                priceOutlet?.text = ""
            } else if IAPHelper.canMakePayments() {
                ProductCell.priceFormatter.locale = product.priceLocale
                priceOutlet?.text = ProductCell.priceFormatter.stringFromNumber(product.price)
                
                accessoryType = .None
                accessoryView = self.newBuyButton()
            } else {
                priceOutlet?.text = "Not available"
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel?.text = ""
        priceOutlet?.text = ""
        accessoryView = nil
    }
    
    func newBuyButton() -> UIButton {
        let button = UIButton(type: .System)
        button.setTitleColor(tintColor, forState: .Normal)
        button.setTitle("Buy", forState: .Normal)
        button.addTarget(self, action: #selector(ProductCell.buyButtonTapped(_:)), forControlEvents: .TouchUpInside)
        button.sizeToFit()
        
        return button
    }
    
    func buyButtonTapped(sender: AnyObject) {
        buyButtonHandler?(product: product!)
    }
}