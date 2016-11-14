//
//  PickIconViewController.swift
//  budget
//
//  Created by Azam Rahmat on 9/2/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit

class PickIconViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    var addCategory = false
    var addSubCategory = false
    var category = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(sender: AnyObject) {
        
        
        Helper.bankIcon = selectedImage
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    let images : [String] = (1...17).map{ i in
        "account" + String(i)
    }
    var selectedImage = ""
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        selectedImage = images[indexPath.row]
        
        //let cell = collectionView.cellForItemAtIndexPath(indexPath)
        // cell!.layer.borderWidth = 2.0
        //cell!.layer.borderColor = UIColor.grayColor().CGColor
        // cell!.contentView.backgroundColor = UIColor.greenColor()
    }/*
     func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
     let cell = collectionView.cellForItemAtIndexPath(indexPath)
     cell?.backgroundColor = UIColor.redColor()
     }*/
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cvcell", forIndexPath: indexPath) as! CustomCollectionViewCell
        // cell.myImage.image = imageAry[indexPath.row]//UIImage(named:"myPic")
        
        
        cell.img?.image = UIImage(named: images[indexPath.row])
        cell.img?.tintColor = Helper.colors[indexPath.row % 5]
        return cell
    }
    
}
