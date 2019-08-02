import Foundation

class RemoveNoteOperation : AsyncOperation {
    private let note: Note
    private let notebook: FileNotebook
    private let removeFromDb: RemoveNoteDBOperation
    private var saveFromBackend: SaveNotesBackendOperation?
    
    private(set) var result: Bool? = false
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.note = note
        self.notebook = notebook
        
        removeFromDb = RemoveNoteDBOperation(uid: note.uid, notebook: notebook)
        
        super.init()
        
        removeFromDb.completionBlock = {
            let saveFromBackend = SaveNotesBackendOperation(notes: notebook.notes)
            self.saveFromBackend = saveFromBackend
            self.addDependency(saveFromBackend)
            backendQueue.addOperation(saveFromBackend)
        }
        
        addDependency(removeFromDb)
        dbQueue.addOperation(removeFromDb)
    }
    
    override func main() {
        switch saveFromBackend!.result! {
        case .success:
            result = true
        case .failure:
            result = false
        }
        finish()
    }
}
