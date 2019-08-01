import Foundation

enum LoadNotesBackendResult {
    case success
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    var result: LoadNotesBackendResult?
    var notes: [Note]?
    
    override func main() {
        result = .failure(.unreachable)
        finish()
    }
}
