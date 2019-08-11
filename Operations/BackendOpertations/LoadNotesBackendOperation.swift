import Foundation

enum LoadNotesBackendResult {
    case success
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    var result: LoadNotesBackendResult?
    var notes: [Note] = []
    var gistsId: String = ""
    
    override func main() {
        loadNotes(
            {(_ gist: Gist?, _ notesFileData: Data?) -> Void in
                self.gistsId = gist?.id ?? ""
                if let notesData = notesFileData {
                    let notesJson = try JSONSerialization.jsonObject(with: notesData, options: []) as! [String: Any]
                    let notesArr = notesJson["notes"] as! [[String:Any]]
                    self.notes = []
                    for noteJson in notesArr {
                        let note = Note.parse(json: noteJson)
                        self.notes.append(note!)
                    }
                }
                self.result = .success
                self.finish()
            },
            {
                self.result = .failure(.unreachable)
                self.finish()
            }
        )
    }
}
