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




var userToken = ""
let notesFileName = "ios-course-notes-db"
var gistsId = ""
var isNotesLoaded = false
