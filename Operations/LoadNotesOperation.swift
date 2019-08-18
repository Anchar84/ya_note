import Foundation
import CoreData

class LoadNotesOperation: AsyncOperation {
    //private let loadFromDb: LoadNotesDBOperation
    private let loadFromBackend: LoadNotesBackendOperation
    
    private(set) var result: Bool? = false
    //private let dbQueue: OperationQueue
    private let backendQueue: OperationQueue
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue,
         backgroundContext: NSManagedObjectContext) {
        
        self.backendQueue = backendQueue
        self.loadFromBackend = LoadNotesBackendOperation()
        super.init()
        
        loadFromBackend.completionBlock = {
            if let result = self.loadFromBackend.result {
                /*
                 Файл в gist для хранения массива заметок в виде JSON должен называться "ios-course-notes-db". Если при загрузке файл с именем "ios-course-notes-db" не был найден, нужно показывать локальный список заметок, иначе - пустой список.
                 */
                switch result  {
                case .success:
                    if self.loadFromBackend.notes.count > 0 { // файл найдет в github, отображаем заметки из него
                        print("fount \(self.loadFromBackend.notes.count) backend notes in \(gistsId)")
                        for note in self.loadFromBackend.notes {
                            notebook.add(note)
                        }
                        /*self.result = true
                        self.finish()*/
                    } else { // файл не найдет в github, отображаем локальный список
                        print("no backend notes found, load local notes list")
                        let loadFromDb = LoadNotesDBOperation(notebook: notebook, backgroundContext: backgroundContext)
                        loadFromDb.completionBlock = {
                            switch self.loadFromBackend.result! {
                            case .success:
                                self.result = true
                            case .failure:
                                self.result = false
                            }
                            self.finish()
                        }
                        self.loadFromBackend.addDependency(loadFromDb)
                        dbQueue.addOperation(loadFromDb)
                    }
                case .failure(_): // иначе отображаем пустой список
                    print("cannot load notes from github, notes are empty")
                    self.result = false
                    self.finish()
                }
            }
        }
        
        
       
    }
    
    override func main() {
        backendQueue.addOperation(loadFromBackend)
    }
}
