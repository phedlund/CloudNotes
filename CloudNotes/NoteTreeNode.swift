//
//  FeedTreeNode.swift
//  CloudNews
//
//  Created by Peter Hedlund on 1/14/19.
//  Copyright © 2019 Peter Hedlund. All rights reserved.
//

import Cocoa

protocol NoteTreeNode: class {
    
    var isLeaf: Bool { get }
    var isGroupItem: Bool { get }
    var childCount: Int { get }
    var children: [NoteTreeNode] { get }
    
    var title: String { get }
    var content: String? { get }
    var modified: NSNumber? { get }

    var sortId: Int { get }
}

class AllNotesNode: NoteTreeNode {

    var sortId: Int {
        return 0
    }
    
    var isLeaf: Bool {
        return true
    }
    
    var isGroupItem: Bool {
        return false
    }

    var childCount: Int {
        var count = 0
        if let notes = CDNote.all() {
            count = notes.count
        }
        return count
    }
    
    var children: [NoteTreeNode] {
        var result = [NoteTreeNode]()
        if let notes = CDNote.all() {
            for note in notes {
                result.append(NoteNode(note: note))
            }
        }
        let sorted = result.sorted {
            if let modified1 = $0.modified?.intValue, let modified2 = $1.modified?.intValue {
                return modified1 > modified2
            }
            return false
        }
        return sorted
    }
    
    var title: String {
        return NSLocalizedString("All", comment: "Item to show all notes")
    }
    
    var content: String? {
        return nil
    }
    
    var modified: NSNumber? {
        return nil
    }
    
}

class StarredNotesNode: NoteTreeNode {

    var sortId: Int {
        return 1
    }

    var isLeaf: Bool {
        return true
    }
    
    var isGroupItem: Bool {
        return false
    }

    var childCount: Int {
        var count = 0
        if let notes = CDNote.starred() {
            count = notes.count
        }
        return count
    }
    
    var children: [NoteTreeNode] {
        var result = [NoteTreeNode]()
        if let notes = CDNote.starred() {
            for note in notes {
                result.append(NoteNode(note: note))
            }
        }
        let sorted = result.sorted {
            if let modified1 = $0.modified?.intValue, let modified2 = $1.modified?.intValue {
                return modified1 > modified2
            }
            return false
        }
        return sorted
    }
    
    var title: String {
        return NSLocalizedString("Favorites", comment: "Item to show favorite notes")
    }
    
    var content: String? {
        return nil
    }
    
    var modified: NSNumber? {
        return nil
    }
    
}

class CategoryNode: NoteTreeNode {

    var sortId: Int {
        return 2
    }

    let category: String
    
    init(category: String) {
        self.category = category
    }
    
    var isLeaf: Bool {
        return true
    }
    
    var isGroupItem: Bool {
        return false
    }

    var childCount: Int {
        var count = 0
        if let notes = CDNote.notes(category: self.category) {
            count = notes.count
        }
        return count
    }
    
    var children: [NoteTreeNode] {
        get {
            var result = [NoteTreeNode]()
            if let notes = CDNote.notes(category: self.category) {
                for note in notes {
                    result.append(NoteNode(note: note))
                }
            }
            let sorted = result.sorted {
                if let modified1 = $0.modified?.intValue, let modified2 = $1.modified?.intValue {
                    return modified1 > modified2
                }
                return false
            }
            return sorted
        }
    }
    
    var title: String {
        if self.category.isEmpty {
            return Constants.noCategory
        }
        return self.category
    }
    
    var content: String? {
        return nil
    }
    
    var modified: NSNumber? {
        return nil
    }
    
}

class NoteNode: NoteTreeNode {

    var sortId: Int {
        return Int(self.note.id) + 1000
    }

    let note: CDNote
    
    init(note: CDNote){
        self.note = note
    }
    
    var isLeaf: Bool {
        return true
    }
    
    var isGroupItem: Bool {
        return false
    }

    var childCount: Int {
        return 0
    }
    
    var children: [NoteTreeNode] {
        return []
    }
    
    var title: String {
        return self.note.title
    }
    
    var content: String? {
        return self.note.content
    }
    
    var modified: NSNumber? {
        return NSNumber(value: self.note.modified)
    }
    
}

class FavoritesNotesNode: NoteTreeNode {

    var sortId: Int {
        return -1
    }

    var isLeaf: Bool {
        return false
    }

    var isGroupItem: Bool {
        return true
    }

    var childCount: Int {
        return 0
    }

    var children: [NoteTreeNode] {
        return []
    }

    var title: String {
        return NSLocalizedString("MAIN", comment: "Header title, main")
    }

    var content: String? {
        return nil
    }

    var modified: NSNumber? {
        return nil
    }

}

class CategoriesNotesNode: NoteTreeNode {

    var sortId: Int {
        return -1
    }

    var isLeaf: Bool {
        return false
    }

    var isGroupItem: Bool {
        return true
    }

    var childCount: Int {
        return 0
    }

    var children: [NoteTreeNode] {
        return []
    }

    var title: String {
        return NSLocalizedString("CATEGORIES", comment: "Header title, categories")
    }

    var content: String? {
        return nil
    }

    var modified: NSNumber? {
        return nil
    }

}
