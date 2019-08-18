import Foundation
import CoreData
import UIKit

class LoadNotesDBOperation: BaseDBOperation {
    
    private let backgroundContext: NSManagedObjectContext
    
    init(notebook: FileNotebook, backgroundContext: NSManagedObjectContext) {
        self.backgroundContext = backgroundContext
        super.init(notebook: notebook)
    }
    
    override func main() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else {return}
            self.backgroundContext.performAndWait {
                let result = NSFetchRequest<DbNote>(entityName: "DbNote")
                do {
                    let notes = try self.backgroundContext.fetch(result)
                    notes.forEach {note in self.notebook.add(self.mapDbNote(note))}
                } catch {
                    print("cannot load db notes: \(error)")
                }
                defer {self.finish()}
            }
        }
    }
    
    private func mapDbNote(_ dbNote: DbNote) -> Note {
        return Note(uid: dbNote.uid!,
                    title: dbNote.title!,
                    content: dbNote.content!,
                    color: UIColor(red: CGFloat(dbNote.colorRed), green: CGFloat(dbNote.colorGreen), blue: CGFloat(dbNote.colorBlue), alpha: CGFloat(dbNote.colorA)),
                    importance: Importance.init(rawValue: dbNote.importance!)!,
                    selfDestructionDate: dbNote.selfDestructionDate as? Date)
    }
}
