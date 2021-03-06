//
//  MenuTabBarController.swift
//  Boii
//
//  Created by Harin Sanghirun on 21/2/58.
//  Copyright (c) พ.ศ. 2558 Harin Sanghirun. All rights reserved.
//

import UIKit

class MenuTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var rest: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = redLabelColor
        self.delegate = self
        
        if let rest = self.rest {
            self.setCustomTitle(rest.name)
            
            let drinkVC = self.viewControllers?[0] as? DrinkCollectionViewController
            let foodVC = self.viewControllers?[1] as? FoodCollectionViewController
            
            drinkVC?.restaurant = rest
            foodVC?.restaurant = rest
            
            self.tabBarController?.selectedViewController = drinkVC

        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let rest = self.rest {
            ShoppingCartStore.sharedInstance.switchToRestaurant(rest)
            ShoppingCartStore.sharedInstance.fetchOrdersWithoutRejected()
        } else {
            log.error("self.rest = \(self.rest)")
        }
    }

    
//    func tabBarController(tabBarController: UITabBarController,
//        didSelectViewController viewController: UIViewController){
//        println(viewController)
//    }
}
