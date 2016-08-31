//
//  NotesEditViewController.swift
//  Soil Identifier
//
//  Created by Keith Edwards on 2015-03-22.
//  Copyright (c) 2015 Keith Edwards. All rights reserved.
//

import UIKit

class NotesEditViewController: UIViewController, UITextViewDelegate {

    var soil: String!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let n = NotesModel.sharedNotesModel.notes[soil] {
            textView.text = n
        }
        
        self.registerForKeyboardNotifications()
    }
    
    @IBAction func eraseNote(sender: AnyObject) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let yesAction = UIAlertAction(title: "Delete Notes", style: UIAlertActionStyle.Destructive, handler: {
            alert in
            self.textView.text = ""
        })
        let noAction = UIAlertAction   (title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        controller.addAction(yesAction)
        controller.addAction(noAction)
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func registerForKeyboardNotifications ()-> Void   {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
        
        
    }
    
    func deregisterFromKeyboardNotifications () -> Void {
        let center:  NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
        center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
        
    }
    
    
    func keyboardWasShown (notification: NSNotification) {
        
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height
        })
        
    }
    
    func keyboardWillBeHidden (notification: NSNotification) {
        self.bottomConstraint.constant = 0
        
        return
    }


    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NotesModel.sharedNotesModel.updateNote(soil, value: textView.text)
        self.deregisterFromKeyboardNotifications()
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
