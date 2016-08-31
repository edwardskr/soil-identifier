//
//  SoilsModel.swift
//  Soil Identifier
//
//  Created by Keith Edwards on 2015-03-22.
//  Copyright (c) 2015 Keith Edwards. All rights reserved.
//

import Foundation

class SoilsModel {
    class var sharedSoilsModel : SoilsModel {
        struct Singleton {
            static let instance = SoilsModel()
        }
        return Singleton.instance
    }
    
    private(set) var soils:[String:[String]]
    private var order:[String: String]
    private var calc:[String: String]
    private var sg:[String: String]
    private var pm:[String: String]
    
    init() {
        let plistURL = NSBundle.mainBundle().URLForResource("soils", withExtension: "plist")
        soils = NSDictionary(contentsOfURL: plistURL!) as [String:[String]]
        
        order = NSDictionary(contentsOfURL: NSBundle.mainBundle().URLForResource("soilsorder", withExtension: "plist")!) as [String: String]
        
        calc = NSDictionary(contentsOfURL: NSBundle.mainBundle().URLForResource("soilscalc", withExtension: "plist")!) as [String: String]
        
        sg = NSDictionary(contentsOfURL: NSBundle.mainBundle().URLForResource("soilssg", withExtension: "plist")!) as [String: String]
        
        pm = NSDictionary(contentsOfURL: NSBundle.mainBundle().URLForResource("soilspm", withExtension: "plist")!) as [String: String]
    }
    
    func getFilteredSoils(filter: [String:[String]]) -> [String:[String]] {
        let soilsSet: NSMutableSet = NSMutableSet(capacity: soils.count)
        soilsSet.addObjectsFromArray(soils.keys.array)
        
        if let sca = filter["Soil Correlation Area"] {
            let scaSet: NSMutableSet = NSMutableSet()
            for (soilSymbol, details) in soils {
                if contains(sca, details[1]){
                    scaSet.addObject(soilSymbol)
                }
            }
            soilsSet.intersectSet(scaSet)
        }
        
        if let calc = filter["Calcareousness"] {
            let calcSet: NSMutableSet = NSMutableSet()
            for (soilSymbol, details) in soils {
                if contains(calc, details[2]){
                    calcSet.addObject(soilSymbol)
                }
            }
            soilsSet.intersectSet(calcSet)
        }
        
        if let pm1 = filter["Parent Material (1)"] {
            let pm1Set: NSMutableSet = NSMutableSet()
            for (soilSymbol, details) in soils {
                if contains(pm1, details[3]){
                    pm1Set.addObject(soilSymbol)
                }
            }
            soilsSet.intersectSet(pm1Set)
        }
        
        if let pm2 = filter["Parent Material (2)"] {
            let pm2Set: NSMutableSet = NSMutableSet()
            for (soilSymbol, details) in soils {
                if contains(pm2, details[4]){
                    pm2Set.addObject(soilSymbol)
                }
            }
            soilsSet.intersectSet(pm2Set)
        }
        
        if let so = filter["Soil Order"] {
            let soSet: NSMutableSet = NSMutableSet()
            for (soilSymbol, details) in soils {
                if contains(so, details[5]){
                    soSet.addObject(soilSymbol)
                }
            }
            soilsSet.intersectSet(soSet)
        }
        
        if let sg = filter["Soil Subgroup"] {
            let sgSet: NSMutableSet = NSMutableSet()
            for (soilSymbol, details) in soils {
                if contains(sg, details[6]){
                    sgSet.addObject(soilSymbol)
                }
            }
            soilsSet.intersectSet(sgSet)
        }
        
        var rDict:[String:[String]] = Dictionary(minimumCapacity: soilsSet.count)

        for item in soilsSet.allObjects {
            let sn = item as String
            rDict[sn] = soils[sn]
        }
        
        return rDict
    }
    
    func getSCAs() -> [String] {
        var SCAs = [String:String]()
        
        for (soilSymbol, details) in soils {
            //if SCAs.indexForKey(details[1])? == nil {
                SCAs[details[1]] = ""
            //}
        }
        
        return sorted(SCAs.keys, {
            (str1: String, str2: String) -> Bool in
            return str1.toInt() < str2.toInt()
        }) as [String]
    }
    
    func getOrders() -> [String] {
        var Orders = [String:String]()
        
        for (soilSymbol, details) in soils {
            if details[5] != "" {
                Orders[details[5]] = ""
            }
        }
        
        return sorted(Orders.keys) as [String]
    }
    
    func getCalcs() -> [String] {
        var Calcs = [String:String]()
        
        for (soilSymbol, details) in soils{
            if details[2] != "" {
                Calcs[details[2]] = ""
            }
        }
        
        return sorted(Calcs.keys) as [String]
    }
    
    func getPM1() -> [String] {
        var PM1 = [String:String]()
        
        for (soilSymbol, details) in soils{
            if details[3] != "" {
                PM1[details[3]] = ""
            }
        }
        
        return sorted(PM1.keys) as [String]
    }
    
    func getPM2() -> [String] {
        var PM2 = [String:String]()
        
        for (soilSymbol, details) in soils{
            if details[4] != "" {
                PM2[details[4]] = ""
            }
        }
        
        return sorted(PM2.keys) as [String]
    }
    
    func getSGs() -> [String] {
        var SG = [String:String]()
        
        for (soilSymbol, details) in soils{
            if details[6] != "" {
                SG[details[6]] = ""
            }
        }
        
        return sorted(SG.keys) as [String]
    }
    
    
    func getSoilsForSCA(sca: String) -> [String: [String]] {
        var soilsList = [String: [String]]()
        
        for (soilSymbol, details) in soils {
            if details[1]==sca {
                soilsList[soilSymbol] = details
            }
        }
        
        return soilsList

    }
    
    func getCalc(calc: String) -> String? {
        return self.calc[calc]
    }
    
    func getOrder(order: String) -> String? {
        return self.order[order]
    }
    
    func getSG(sg: String) -> String? {
        return self.sg[sg]
    }
    
    func getPM(pm: String) -> String? {
        return self.pm[pm]
    }
}
