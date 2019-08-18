import Foundation
import CoreData
import UIKit

class RemoveNoteDBOperation: BaseDBOperation {
    
    private let note: Note
    private let backgroundContext: NSManagedObjectContext
    
    
    init(note: Note,
         notebook: FileNotebook,
         backgroundContext: NSManagedObjectContext) {
        self.note = note
        self.backgroundContext = backgroundContext
        super.init(notebook: notebook)
    }
    
    override func main() {
        notebook.remove(with: note.uid)
        
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let `self` = self else {return}
            let result = NSFetchRequest<DbNote>(entityName: "DbNote")
            do {
                let notes = try self.backgroundContext.fetch(result)
                let dbNote = notes.first(where: {n in n.uid == self.note.uid})
                if let dbNote = dbNote {
                    self.backgroundContext.delete(dbNote)
                }
            } catch {
                print("cannot delete db note: \(error)")
            }
            
            defer {
                self.notebook.save()
                self.finish()
            }
            
        }
        //notebook.save()
        //finish()
    }
}
