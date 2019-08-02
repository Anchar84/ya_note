import Foundation

class LoadNotesDBOperation: BaseDBOperation {
    
    override func main() {
        notebook.load()
        finish()
    }
}
