//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Ibrahim.Moustafa on 2/12/16.
//  Copyright © 2016 Ibrahim.Moustafa. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewcontroller: UIViewController {
    
    var memeIndex:Int!
    
    @IBOutlet weak var imgMain: UIImageView!
    
    // handle delete meme
    @IBAction func btnDeleteClick(sender: AnyObject) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.removeAtIndex(memeIndex)
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // display memed image depeding on passed index
        if let curindex = memeIndex {
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            imgMain.image = appDelegate.memes[curindex].memedImage
            imgMain.contentMode = .ScaleAspectFit
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "editmeme")
        {
            
            let vc = segue.destinationViewController as! MemeEditorViewController
            vc.memeIndex = memeIndex
            
        }
    }
}
