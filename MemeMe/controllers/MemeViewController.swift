//
//  ViewController.swift
//  ComicMaker
//
//  Created by Ahmed Elgendy on 12/06/2017.
//  Copyright © 2017 Ahmed Elgendy. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var keyboardIsShown = false

    let textFieldDelegate = TextFieldDelegate()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotification()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unSubscribeToKeyboardNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
    }
    
    func setupDelegates(){
        self.topText.delegate = textFieldDelegate
        self.bottomText.delegate = textFieldDelegate
    }
    
    func setupUI(){
        
        let memeTextAttributes:[String:Any] = [
            NSForegroundColorAttributeName: UIColor.white ,
            NSStrokeColorAttributeName: UIColor.black,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 24)!,
            NSStrokeWidthAttributeName: 5.0]
        
        self.topText.defaultTextAttributes = memeTextAttributes
        self.bottomText.defaultTextAttributes = memeTextAttributes
        
        self.topText.textAlignment = NSTextAlignment.center
        self.bottomText.textAlignment = NSTextAlignment.center
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        shareBtn.isEnabled = false
    }
    
    enum ButtonSourceType : Int {
        case camera = 0, gallery
    }

    @IBAction func pickaPicture(_ sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        switch ButtonSourceType(rawValue:sender.tag)!{
            case .camera:
                imagePicker.sourceType = .camera
            case .gallery:
                imagePicker.sourceType = .photoLibrary
        }
        
        self.present(imagePicker, animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            shareBtn.isEnabled = true
        }else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveMeme(){
        
        let memedImage = generateMemedImage()
        
        _ = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
    }
    
    
    @IBAction func shareIT(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)

        activityVC.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                //Save the image
                self.saveMeme()
                print("image saved")
            }
        }

        
        self.present(activityVC, animated: true, completion: nil)
    }

    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        navBar.isHidden = true
        toolbar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
            let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navBar.isHidden = false
        toolbar.isHidden = false
        
        return memedImage
    }
    

    
    @IBAction func cancelForReset() {
        imagePickerView.image = nil
        topText.text = "Top"
        bottomText.text = "Bottom"
        shareBtn.isEnabled = false
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        if !keyboardIsShown{
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
        keyboardIsShown = true

    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        
        if keyboardIsShown{
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
        keyboardIsShown = false
    }
    
    func getKeyboardHeight(_ notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
        
    }
    
    func subscribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unSubscribeToKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
}

