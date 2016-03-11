//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Ibrahim.Moustafa on 1/30/16.
//  Copyright © 2016 Ibrahim.Moustafa. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
    
    var selectedRow:Int!
    
    var memes: [Meme]! {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // if no memes exist then goto add new meme
        if memes.count == 0 {
            performSegueWithIdentifier("addmeme", sender: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let curcell = tableView.dequeueReusableCellWithIdentifier("memecell", forIndexPath: indexPath) as! MemeUITableViewCell
        let curmeme = memes[indexPath.row]
        curcell.lblTitleA.text = curmeme.topText
        curcell.lblTitleB.text = curmeme.bottomText
        curcell.imgMeme.image = curmeme.image
        
        return curcell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
        performSegueWithIdentifier("DisplayMeme", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "DisplayMeme")
        {
            let vc = segue.destinationViewController as! MemeDetailViewcontroller
            vc.memeIndex = selectedRow
        }
    }
    
    // enable row edit to allow delete
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)
            tableView.reloadData()

        }
    }
}