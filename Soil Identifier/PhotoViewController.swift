//
//  PhotoViewController.swift
//  ABSoilInfo
//
//  Created by Keith Edwards on 2015-04-01.
//  Copyright (c) 2015 Keith Edwards. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageSize = CGSizeMake(0,0)
    
    var imageView: UIImageView! = UIImageView()
    
    var imageName: String!
    
    var fullPath: String!
    
    var soil: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        fullPath = documentsPath.stringByAppendingPathComponent("\(imageName!).jpg")
        
        let image = UIImage(contentsOfFile: fullPath!)!
            
        imageView = UIImageView(image: image)
        
        scrollView.contentSize = imageView.frame.size
        
        imageSize = imageView.frame.size
        
        scrollView.addSubview(imageView)
        
        var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        // 1
        let pointInView = recognizer.locationInView(imageView)
        
        // 2
        var newZoomScale = scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        // 3
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        // 4
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }

    
    override func viewDidLayoutSubviews() {
        scrollView.maximumZoomScale = 3.0
        scrollView.contentSize = imageSize
        let widthScale = scrollView.bounds.size.width / imageSize.width
        let heightScale = scrollView.bounds.size.height / imageSize.height
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        
        scrollView.setZoomScale(min(widthScale, heightScale), animated: false )
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    @IBAction func deletePhoto(sender: AnyObject) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let yesAction = UIAlertAction(title: "Delete Photo", style: UIAlertActionStyle.Destructive, handler: {
            alert in
            var error: NSError?
            NSFileManager.defaultManager().removeItemAtPath(self.fullPath, error: &error)
            PhotosModel.sharedPhotosModel.removePhoto(self.soil, withPhoto: self.imageName)
            self.navigationController?.popViewControllerAnimated(true)
        })
        let noAction = UIAlertAction   (title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        controller.addAction(yesAction)
        controller.addAction(noAction)
        
        presentViewController(controller, animated: true, completion: nil)
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
