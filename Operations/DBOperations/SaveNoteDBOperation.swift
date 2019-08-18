import Foundation
import CoreData
import UIKit

class SaveNoteDBOperation: BaseDBOperation {
    private let note: Note
    private let backgroundContext: NSManagedObjectContext
    
    
    init(note: Note, notebook: FileNotebook, backgroundContext: NSManagedObjectContext ) {
        self.note = note
        self.backgroundContext = backgroundContext
        
        super.init(notebook: notebook)
    }
    
    override func main() {
        
        
        
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let `self` = self else {return}
            let note = self.note
            let dbNote = DbNote(context: self.backgroundContext)
            dbNote.uid = note.uid
            dbNote.title = note.title
            dbNote.content = note.content
            dbNote.importance = "\(note.importance)"
            if note.selfDestructionDate != nil {
                dbNote.selfDestructionDate = note.selfDestructionDate as NSDate?
            }
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            note.color.getRed(&r, green: &g, blue: &b, alpha: &a)
            dbNote.colorRed = Float(r)
            dbNote.colorGreen = Float(g)
            dbNote.colorBlue = Float(b)
            dbNote.colorA = Float(a)
            self.backgroundContext.performAndWait {
                do {
                    try self.backgroundContext.save()
                } catch {
                    print("cannot save note to db: \(error)")
                }
            }
            
            defer {
                self.notebook.add(note)
                self.finish()
            }
            
        }
        //        notebook.add(note)
        //        notebook.save()
        //        finish()
    }
}
