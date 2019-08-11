import Foundation

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    var result: SaveNotesBackendResult?
    var notes: [Note] = []
    
    init(notes: [Note]) {
        super.init()
        self.notes = notes
    }
    
    override func main() {
        var notesJson :[String: Any] = [:]
        notesJson["notes"] = notes.map {$0.json}
        do {
            var gist = GistMode()
            gist.files[notesFileName] = GistFileMode()
            
            let notesData = try JSONSerialization.data(withJSONObject: notesJson, options: [])
            gist.files[notesFileName]?.content = String(data: notesData, encoding: .utf8)
            
            let urlString = gistsId.isEmpty ? "https://api.github.com/gists" : "https://api.github.com/gists/\(gistsId)"
            guard let url = URL(string: urlString) else {
                print("cannot create url")
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = gistsId.isEmpty ? "POST" : "PATCH"
            request.addValue("token \(userToken)", forHTTPHeaderField: "Authorization")
            request.httpBody = try! JSONEncoder().encode(gist)
            
            let task = URLSession.shared.dataTask(with: request) {(date, response, error) in 
                guard let date = date else {
                    self.result = .failure(.unreachable)
                    self.finish()
                    return
                }
                self.result = .success
                self.finish()
                
            }
            task.resume()
        } catch {
            print("save error: \(error)")
            result = .failure(.unreachable)
            finish()
        }
    }
}
