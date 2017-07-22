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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let textFieldDelegate = TextFieldDelegate()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unSubscribeToKeyboardNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        
        let memeTextAttributes:[String:Any] = [
            NSForegroundColorAttributeName: UIColor.white ,
            NSStrokeColorAttributeName: UIColor.black,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 28)!,
            NSStrokeWidthAttributeName: -8.0]
        
        configureTextFields(textField: topText, defaultAttributes: memeTextAttributes)
        configureTextFields(textField: bottomText, defaultAttributes: memeTextAttributes)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        shareBtn.isEnabled = false
    }
    
    func configureTextFields(textField:UITextField, defaultAttributes: [String:Any]){
        textField.defaultTextAttributes = defaultAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.delegate = textFieldDelegate
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
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            shareBtn.isEnabled = true
        }else{
            print("Something went wrong")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func saveMeme(){
        
        let memedImage = generateMemedImage()
        
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        appDelegate.memes.append(meme)
    }
    
    
    @IBAction func shareIT(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                //Save the meme
                self.saveMeme()
            }
        }
        present(activityVC, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        configureBars(hidden: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        configureBars(hidden: false)
        
        return memedImage
    }
    
    func configureBars(hidden: Bool){
        navBar.isHidden = hidden
        toolbar.isHidden = hidden
    }
    
    @IBAction func hideMemeEditor() {
        dismiss(animated: true, completion: nil)
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        if bottomText.isFirstResponder{
            self.view.frame.origin.y -= getKeyboardHeight(notification)
            keyboardIsShown = true
        }
        if topText.isFirstResponder && keyboardIsShown {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        if bottomText.isFirstResponder {
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

