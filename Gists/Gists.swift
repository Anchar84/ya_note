import Foundation

struct GistList: Codable {
    let gists: [Gist]
}

struct Gist: Codable {
    var id: String?
    var url: String?
    var `public`: Bool?
    var created_at: String?
    var comments: Int?
    var files: [String: GistFile] = [:]
    var owner: Owner?
}

struct Owner: Codable {
    let login: String
}

struct GistFile: Codable {
    var filename: String? = nil
    var raw_url: String
    var content: String? = nil
}

struct GistMode: Codable {
    var files: [String: GistFileMode] = [:]
}

struct GistFileMode: Codable {
    var filename: String? = nil
    var content: String? = nil
}


func loadNotes(_ onSuccess:@escaping (_ gist: Gist?, _ notesFileDate: Data?) throws -> Void, _ onError: @escaping () -> Void) {
    guard let url = URL(string: "https://api.github.com/gists") else {
        print("cannot create url")
        return
    }
    var request = URLRequest(url: url)
    request.addValue("token \(userToken)", forHTTPHeaderField: "Authorization")
    URLSession.shared.dataTask(with: request) {(date, response, error) in
        var isHttpOk = false
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 200..<300:
                isHttpOk = true
            default:
                onError()
                return
            }
        }
        print("loadNotes isHttpOk: \(isHttpOk)")
        guard let date = date else {
            onError()
            return
        }
        do {
            let gists = try JSONDecoder().decode([Gist].self, from: date)
            let gist = gists.first(where: {gist in gist.files[notesFileName] != nil})
            guard let notesGits = gist, gist?.files[notesFileName]?.raw_url != nil  else {
                try onSuccess(nil, nil)
                return
            }
            let fileUrl = notesGits.files[notesFileName]!.raw_url
            URLSession.shared.dataTask(with: URL(string: fileUrl)!) {(date, response, error) in
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200..<300:
                        isHttpOk = true
                    default:
                        onError()
                        return
                    }
                }
                do {
                    gistsId = gist?.id ?? ""
                    try onSuccess(gist, date)
                } catch {
                    print("parse error: \(error)")
                    onError()
                }
            }.resume()
        } catch {
            print("parse error: \(error)")
            onError()
        }
        
        }.resume()
}


var userToken = "804f3b12e2457dde8f8aeda6b429ba5025103e29"
let notesFileName = "ios-course-notes-db"
var gistsId = ""
var isNotesLoaded = false
