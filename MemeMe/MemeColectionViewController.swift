//
//  MemeColectionViewController.swift
//  MemeMe
//
//  Created by Ibrahim.Moustafa on 2/13/16.
//  Copyright © 2016 Ibrahim.Moustafa. All rights reserved.
//

import Foundation
import UIKit

class MemeColectionViewController : UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    var selectedRow: Int!
    
    var memes: [Meme]! {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    // adjust spacing between cells depending on view size
    func setMemesSpacing(viewSize: CGSize){
        let spacing: CGFloat = 3.0
        let dimention:CGFloat = (viewSize.width - (spacing * 2)) / 3.0
        if flowLayout != nil{
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        flowLayout.itemSize = CGSizeMake(dimention, dimention)
    }
    }
    
    override func viewWillAppear(animated: Bool) {
        //adjust spacing
        setMemesSpacing(view.frame.size)
        // reload collection to view new added memes or edited memes
        collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memecell", forIndexPath: indexPath)
        cell.backgroundView = UIImageView(image: memes[indexPath.row].memedImage)
        return cell
    }
    
    // adjust spacing if screen rotated
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        setMemesSpacing(size)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
        performSegueWithIdentifier("DisplayMeme", sender: nil)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // goto view details controller and pass the meme index
        if(segue.identifier == "DisplayMeme")
        {
            let vc = segue.destinationViewController as! MemeDetailViewcontroller
            vc.memeIndex = selectedRow
        }
    }
    
}