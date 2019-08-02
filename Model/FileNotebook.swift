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
        if let cachePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let json = self.notes.map { $0.json }
            do {
                let data = try JSONSerialization.data(withJSONObject: json, options: [])
                let path = cachePath.appendingPathComponent("notebook")
                FileManager.default.createFile(atPath: path.path, contents: data, attributes: nil)
            } catch let error {
                print("Can't save notes to file: \(error.localizedDescription)")
            }
        }
    }
    
    public func load() {
        if let cachePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let path = cachePath.appendingPathComponent("notebook")
                if let data = FileManager.default.contents(atPath: path.path) {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
                    _ = json.map { self.notes.append(Note.parse(json: $0)!) }
                }
            } catch let error {
                print("Can't load notes from cache: \(error.localizedDescription)")
            }
        }
    }
}
