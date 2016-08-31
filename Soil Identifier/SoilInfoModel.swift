//
//  SoilInfoModel.swift
//  Soil Identifier
//
//  Created by Keith Edwards on 2015-03-23.
//  Copyright (c) 2015 Keith Edwards. All rights reserved.
//

import Foundation

class SoilInfoModel {
    class var sharedSoilInfoModel : SoilInfoModel {
        struct Singleton {
            static let instance = SoilInfoModel()
        }
        return Singleton.instance
    }
    
    private(set) var soilInfo:[String:[String:[String:[String]]]]
    
    init() {
        soilInfo = NSDictionary(contentsOfURL: NSBundle.mainBundle().URLForResource("soilinfo", withExtension: "plist")!) as [String:[String:[String:[String]]]]
    }
}