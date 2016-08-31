//
//  SoilPhotoCollectionViewController.swift
//  ABSoilInfo
//
//  Created by Keith Edwards on 2015-04-01.
//  Copyright (c) 2015 Keith Edwards. All rights reserved.
//

import UIKit

let reuseIdentifier = "PhotoCell"

class SoilPhotoCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    var soil:String!
    
    var picker:UIImagePickerController=UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.registerClass(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        
        
        // Do any additional setup after loading the view.
        /*
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            cameraButton.enabled = false
        }
        */
        
        picker.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func takePicture(sender: AnyObject) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: {
            alert in
            self.picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.picker.allowsEditing = false
            self.presentViewController(self.picker, animated: true, completion: nil)
        })
        
        let photoAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default, handler: {
            alert in
            self.picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.picker.allowsEditing = false
            self.presentViewController(self.picker, animated: true, completion: nil)
            })
        
        let noAction = UIAlertAction   (title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            controller.addAction(cameraAction)
        }
        
        controller.addAction(photoAction)
        controller.addAction(noAction)
        
        presentViewController(controller, animated: true, completion: nil)
        
        
        
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        let imageData:NSData = UIImageJPEGRepresentation(image, 0.8)
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let ts = "\(NSDate().timeIntervalSince1970)"
        let savedImagePath = documentsPath.stringByAppendingPathComponent("\(ts).jpg")
        
        
        imageData.writeToFile(savedImagePath, atomically: false)
        PhotosModel.sharedPhotosModel.addPhoto(soil, withPhoto: ts)
        
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.collectionView?.reloadData()
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
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        if let c = PhotosModel.sharedPhotosModel.photos[soil]?.count {
            return c
        } else {
            return 0
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PhotoCollectionViewCell
    
        // Configure the cell
        cell.backgroundColor = UIColor.blackColor()
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let savedImagePath = documentsPath.stringByAppendingPathComponent("\(PhotosModel.sharedPhotosModel.photos[soil]![indexPath.row]).jpg")

        if NSFileManager.defaultManager().fileExistsAtPath(savedImagePath){
            //let img = UIImage(contentsOfFile: savedImagePath)!
            cell.imageView.image = UIImage(contentsOfFile: savedImagePath)!

        }
        
      
        
        
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = self.view.frame.size.width - 2
        let third = Int(width)/3
        //println(third)
        
        return CGSize(width: third, height: third)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let PhotoVC = segue.destinationViewController as PhotoViewController
        
        let cell = sender as UICollectionViewCell
        let indexPath = collectionView!.indexPathForCell(cell)!
        let image = PhotosModel.sharedPhotosModel.photos[soil]![indexPath.row]
        PhotoVC.imageName = image
        PhotoVC.soil = self.soil
        PhotoVC.navigationItem.title = ""
    }
    

}
