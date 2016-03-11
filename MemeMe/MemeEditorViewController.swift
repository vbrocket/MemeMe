//
//  ViewController.swift
//  MemeMe
//
//  Created by Ibrahim.Moustafa on 1/18/16.
//  Copyright © 2016 Ibrahim.Moustafa. All rights reserved.
//

import UIKit

class MemeEditorViewController : UIViewController , UIImagePickerControllerDelegate ,UINavigationControllerDelegate,UITextFieldDelegate {
    var vcImagePicker:UIImagePickerController = UIImagePickerController()
    
    var vcActivityView:UIActivityViewController!
    
    var memeIndex: Int!
    
    @IBOutlet weak var imgSelectedImage: UIImageView!
    @IBOutlet weak var btnOpenCamera: UIBarButtonItem!
    
    @IBOutlet weak var btnShare: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    
    @IBOutlet weak var txtTop: UITextField!
    @IBOutlet weak var txtButtom: UITextField!
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // define memed image
    var memedImage:UIImage!
    
    // current active text field
    var activeField: UITextField?
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "Impact", size: 35)!,
        NSStrokeWidthAttributeName : -3    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // initialize image picker properites
        vcImagePicker.delegate = self
        vcImagePicker.allowsEditing = false
        
        // set image view to aspect fit
        imgSelectedImage.contentMode = .ScaleAspectFit
        
        // initialize top and bottom text boxes
        initTextBoxes(txtTop , text: "TOP")
        initTextBoxes(txtButtom, text: "BUTTOM")
        
        // if we have current meme index from aother controller then activate edit mode
        if let curIndex = memeIndex {
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            txtTop.text = appDelegate.memes[curIndex].topText
            txtButtom.text = appDelegate.memes[curIndex].bottomText
            imgSelectedImage.image = appDelegate.memes[curIndex].image
        }
        else{
        // update UI status to new state
        updateUIStatus(false)
        }
        
       
        
        // diable camera button if not availble
        btnOpenCamera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    // initialize any text box with required app attributes and set delegates
    func initTextBoxes(txtField: UITextField, text: String){
        txtField.defaultTextAttributes = memeTextAttributes
        txtField.textAlignment = .Center
        txtField.text = text
        txtField.delegate = self //txtDelegate
        txtField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // library button click
    @IBAction func btnPickImageClick(sender: UIBarButtonItem) {
        vcImagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(vcImagePicker, animated: true, completion: nil)
        
    }
    
    // camera button click
    @IBAction func btnCameraImageClick(sender: UIBarButtonItem) {
        vcImagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(vcImagePicker, animated: true, completion: nil)
        
    }
    
    // if picture picked
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            imgSelectedImage.image = pickedImage
            // Set UI state to be in Edit mode
            updateUIStatus(true)
            picker.dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
    
    // if picture picker canceled
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // activity button clicked
    @IBAction func btnShareClick(sender: UIBarButtonItem) {
        
        memedImage = generateMemedImage()
        vcActivityView = UIActivityViewController(activityItems: [memedImage] , applicationActivities: nil )
        vcActivityView.completionWithItemsHandler = activityCompletionHandler
        presentViewController(vcActivityView, animated: true, completion: nil)
        
    }
    
    // handle ativity response
    func activityCompletionHandler (type:String?, complete:Bool,info:[AnyObject]?,er:NSError?) {
        // if activity completed then save
        if complete{
            // save meme
            saveMeme()
            updateUIStatus(false)

        }
    }
    
    // save Meme not fully implmentd yet
    //TODO: implement it in Meme V2.0
    func saveMeme() {
        //Create the meme
        let meme = Meme(topText: txtTop.text!, bottomText: txtButtom.text!, image: imgSelectedImage.image!, memedImage: memedImage!)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        // if editing exsisting meme
        if let curindex = memeIndex {
            appDelegate.memes[curindex] = meme
        }
        else{
            appDelegate.memes.append(meme)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // cancel edited meme
    @IBAction func btnCancelClick(sender: UIBarButtonItem){
        // reset UI state to new
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Set UI state to be New Or Edit Mode
    func updateUIStatus(isEditMode:Bool){
        btnShare.enabled = isEditMode
        
        if !isEditMode {
            txtButtom.text = "TOP"
            txtTop.text = "BUTTOM"
            if imgSelectedImage.image != nil {
                imgSelectedImage.image = nil
            }
        }
        
        
    }
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Empty text field when activated
        textField.text = ""
        textField.autocapitalizationType = .AllCharacters
        
        // set current active text field to insure later keyboard don't override it.
        activeField = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // hide keyboad when hit Enter
        textField.resignFirstResponder()
        
        return true;
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // listen to keyboard notification
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // stop listening to keyboard before leaving view
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func subscribeToKeyboardNotifications() {
        // listen to keyoard show
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        // lesten to keyboard hide
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        // if current active text field is the buttom one then move the view up to keep it visible for user
        if activeField == txtButtom {
            // move view up with keyboard height
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // retutn view to it's original state when keyboard hide
        view.frame.origin.y = 0
    }
    
    // get keyboard height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    
    // Generate Meme image
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        navBar.hidden = true
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        navBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }
}

