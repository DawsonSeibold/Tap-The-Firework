//
//  iAPProducts.swift
//  Project20
//
//  Created by Dawson Seibold on 4/19/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import Foundation


public struct iapProducts {
    
    private static let Prefix = "tapTheFierwork."
    
    public static let GirlfriendOfDrummerRage = Prefix + "removeAds"
    
    private static let productIdentifiers: Set<ProductIdentifier> = [iapProducts.GirlfriendOfDrummerRage]
    
    public static let store = IAPHelper(productIds: iapProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(productIdentifier: String) -> String? {
    return productIdentifier.componentsSeparatedByString(".").last
}
