//
//  DrinkCollectionViewController.swift
//  Boii
//
//  Created by Harin Sanghirun on 4/2/58.
//  Copyright (c) พ.ศ. 2558 Harin Sanghirun. All rights reserved.
//

import UIKit

private let reuseIdentifier = "drinkMenuCell"

class DrinkCollectionViewController:
    UICollectionViewController,
    UICollectionViewDelegateFlowLayout
    {
    
    let defaultThumbnail : UIImage? = UIImage(named: "starbuck_coffee.jpg")
    var menu: [MenuItem]?
    var selectedMenu: MenuItem?
    var restaurant: Restaurant?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = restaurant?.name

        // Do any additional setup after loading the view.
        
        let barButton = CartBarButtonItem.sharedInstance
        barButton.isLoggedIn = true
        
        self.tabBarController?.navigationItem.rightBarButtonItem = barButton
        
//        self.edgesForExtendedLayout = UIRectEdge.All
//        self.collectionView?
        
            //UIEdgeInsetsMake(0.0, 0.0, CGRectGetHeight(self.tabBarController?.tabBar.frame.height), 0.0)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let barButton = self.tabBarController?.navigationItem.rightBarButtonItem as CartBarButtonItem
        barButton.viewController = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let menu = self.restaurant?.drinks {
            return menu.count
        }
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as MenuCollectionViewCell
        
        let index = indexPath.row
        if let menu = self.restaurant?.drinks {
            cell.priceLabel.text = "฿ \(menu[index].price)"
            cell.titleLabel.text = menu[index].name
            cell.initImage(menu[index].thumbnailImage!)
        }

        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let contentView = NSBundle.mainBundle().loadNibNamed("MenuDetailView", owner: self, options: nil).first as UIView
        
        if let menu = self.restaurant?.drinks {
            let imageView = contentView.viewWithTag(301) as UIImageView
            
            self.selectedMenu = menu[indexPath.row]

            imageView.image = selectedMenu!.thumbnailImage
            imageView.clipsToBounds = true
            
            let addToCartButton = contentView.viewWithTag(401) as UIButton
            addToCartButton.addTarget(self, action: "addButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            let cancelButton = contentView.viewWithTag(402) as UIButton
            cancelButton.addTarget(self, action: "cancelButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            
            
            let popup = KLCPopup(contentView: contentView)
            popup.show()
        } else {
            println(menu)
        }
    }
    
    func cancelButtonPressed(sender: AnyObject) {
        if sender is UIView {
            sender.dismissPresentingPopup()
        }
    }
    
    func addButtonPressed(sender: AnyObject) {
        println("addButtonPressed")
        
        // Check and Initialize Shopping Cart
        if ShoppingCartStore.sharedInstance.restaurant == nil {
            println("\(_stdlib_getTypeName(self)): Initializing CartStore's restaurant")
            ShoppingCartStore.sharedInstance.restaurant = self.restaurant
        }
        
        if let ID = self.restaurant?._id {
            if ShoppingCartStore.sharedInstance.restaurant?._id == ID {
            
                if let order = selectedMenu? {
                    ShoppingCartStore.sharedInstance.toOrder.append(order)
                } else {
                    println("failed to add to cart")
                }
                
                if sender is UIView {
                    sender.dismissPresentingPopup()
                }
            } else {
                //ask to change restaurant
                
                let msg = "Would you like to change your current restaurant to \(self.restaurant!.name)"
                let alert = UIAlertController(title: "This is a different restaurant", message: msg, preferredStyle: UIAlertControllerStyle.Alert);
                let YESAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
                    (action) in
                    
                    ShoppingCartStore.sharedInstance.switchToRestaurant(self.restaurant!)
                }
                
                let NOAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel) { (action) in
                    
                }
                
                alert.addAction(YESAction)
                alert.addAction(NOAction)
                
                KLCPopup.dismissAllPopups()
                
                self.presentViewController(alert, animated: true) {
                    
                }
            }
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,right: 0)
    private let interitemSpacing: CGFloat = 0.5
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = self.view.frame.width / 2 -  interitemSpacing
        let height = (4 * width) / 3
        
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return interitemSpacing
    }
    
    
    

}