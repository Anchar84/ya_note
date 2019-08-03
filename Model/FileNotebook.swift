import Foundation
import UIKit

class FileNotebook {
    private(set) var notes: [Note] = []
    
    var getNotes: [Note] {
        return notes
    }
    
    public func add(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.uid == note.uid }) {
            notes[index] = note
        } else {
            notes.append(note)
        }
    }
    
    public func remove(with uid: String) {
        if let idx = notes.firstIndex(where: {note in note.uid == uid}) {
            notes.remove(at: idx)
        }
    }
    
    public func save() {
        var notesJson :[String: Any] = [:]
        notesJson["notes"] = notes.map {$0.json}
        do {
            let notesData = try JSONSerialization.data(withJSONObject: notesJson, options: [])
            if let cachePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let path = cachePath.appendingPathComponent("notebook")
                FileManager.default.createFile(atPath: path.path, contents: notesData, attributes: nil)
            }
        } catch {
            print("save error: \(error)")
        }
    }
    
    public func load() {
        do {
            if let cachePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let path = cachePath.appendingPathComponent("notebook")
                let notesDate = try Data(contentsOf: path)
                let notesJson = try JSONSerialization.jsonObject(with: notesDate, options: []) as! [String: Any]
                let notesArr = notesJson["notes"] as! [[String:Any]]
                for noteJson in notesArr {
                    let note = Note.parse(json: noteJson)
                    add(note!)
                }
            }
        } catch {
            print("load error \(error)")
        }
    }
}
