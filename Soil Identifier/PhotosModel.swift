//
//  PhotosModel.swift
//  ABSoilInfo
//
//  Created by Keith Edwards on 2015-04-01.
//  Copyright (c) 2015 Keith Edwards. All rights reserved.
//

import Foundation

class PhotosModel {
    class var sharedPhotosModel: PhotosModel {
        struct Singleton {
            static let instance = PhotosModel()
        }
        return Singleton.instance
    }
    
    private(set) var photos:[String:[String]]
    
    init() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let storedPhotos = defaults.objectForKey("photos") as? [String:[String]]
        photos = storedPhotos != nil ? storedPhotos! : [:]
    }
    
    
    func addPhoto(soil: String, withPhoto photoPath: String){
        let stupidhack = self.photos
        
        if photos.indexForKey(soil) == nil {
            photos[soil] = [] as [String]
        }
        
        photos[soil]?.append(photoPath)
        
        savePhotos()
    }
    
    func removePhoto(soil: String, withPhoto photoPath: String){
        let stupidhack = self.photos
        
        if photos.indexForKey(soil) == nil {
            photos[soil] = [] as [String]
        }
        
        if let i = find(photos[soil]!, photoPath) {
            photos[soil]?.removeAtIndex(i)
        }
        
        savePhotos()
    }
    
    private func savePhotos()
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(photos, forKey: "photos")
        defaults.synchronize()
    }
}