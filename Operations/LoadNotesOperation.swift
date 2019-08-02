import Foundation

class LoadNotesOperation: AsyncOperation {
    private let notebook: FileNotebook
    private let loadFromDb: LoadNotesDBOperation
    private var loadFromBackend: LoadNotesBackendOperation?
    
    private(set) var result: Bool? = false
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.notebook = notebook
        
        loadFromDb = LoadNotesDBOperation(notebook: notebook)
        
        super.init()
        
        loadFromDb.completionBlock = {
            let loadFromBackend = LoadNotesBackendOperation()
            self.loadFromBackend = loadFromBackend
            self.addDependency(loadFromBackend)
            backendQueue.addOperation(loadFromBackend)
        }
        
        addDependency(loadFromDb)
        dbQueue.addOperation(loadFromDb)
    }
    
    override func main() {
        switch loadFromBackend!.result! {
        case .success:
            result = true
        case .failure:
            result = false
        }
        finish()
    }
}
