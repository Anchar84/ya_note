import Foundation

class RemoveNoteDBOperation: BaseDBOperation {
    
    private let uid: String
    
    init(uid: String,
         notebook: FileNotebook) {
        self.uid = uid
        super.init(notebook: notebook)
    }
    
    override func main() {
        notebook.remove(with: uid)
        finish()
    }
}
