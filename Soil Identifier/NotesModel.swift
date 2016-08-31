//
//  NotesModel.swift
//  Soil Identifier
//
//  Created by Keith Edwards on 2015-03-22.
//  Copyright (c) 2015 Keith Edwards. All rights reserved.
//

import Foundation

class NotesModel {
    class var sharedNotesModel: NotesModel {
        struct Singleton {
            static let instance = NotesModel()
        }
        return Singleton.instance
    }
    
    private(set) var notes:[String:String]
    
    init() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let storedNotes = defaults.objectForKey("notes") as? [String:String]
        notes = storedNotes != nil ? storedNotes! : [:]
    }
    
    
    func updateNote(key: String, value: String){
        let stupidhack = self.notes
        //self.notes.updateValue(value, forKey: key)
        notes[key]=value
        saveNotes()
    }
    
    private func saveNotes()
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(notes, forKey: "notes")
        defaults.synchronize()
    }
}