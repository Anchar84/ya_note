import Foundation

class LoadNotesOperation: AsyncOperation {
    private let loadFromDb: LoadNotesDBOperation
    private var loadFromBackend: LoadNotesBackendOperation?
    
    private(set) var result: Bool? = false
    private let dbQueue: OperationQueue;
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        
        loadFromDb = LoadNotesDBOperation(notebook: notebook)
        self.dbQueue = dbQueue
        
        super.init()
        
        loadFromDb.completionBlock = {
            let loadFromBackend = LoadNotesBackendOperation()
            
            loadFromBackend.completionBlock = {
                guard let notes = loadFromBackend.notes else {return}
                for note in notes {
                    notebook.add(note) // добавление данных в коллекцию, если заметка с таким uid уже есть она обновиться
                }
                switch loadFromBackend.result! {
                case .success:
                    self.result = true
                case .failure:
                    self.result = false
                }
                self.finish()
            }
            backendQueue.addOperation(loadFromBackend)
        }
    }
    
    override func main() {
        dbQueue.addOperation(loadFromDb)
    }
}
