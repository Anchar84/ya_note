import Foundation

class RemoveNoteOperation : AsyncOperation {
    private let removeFromDb: RemoveNoteDBOperation
    private let dbQueue: OperationQueue
    
    private(set) var result: Bool? = false
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        
        self.dbQueue = dbQueue
        removeFromDb = RemoveNoteDBOperation(uid: note.uid, notebook: notebook)
        
        super.init()
        
        removeFromDb.completionBlock = {
            let saveFromBackend = SaveNotesBackendOperation(notes: notebook.notes)
            saveFromBackend.completionBlock = {
                switch saveFromBackend.result! {
                case .success:
                    self.result = true
                case .failure:
                    self.result = false
                }
                self.finish()
            }
            backendQueue.addOperation(saveFromBackend)
        }
    }
    
    override func main() {
        dbQueue.addOperation(removeFromDb)
    }
}
