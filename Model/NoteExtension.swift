import UIKit
import Foundation

extension Note {
    static func parse(json: [String: Any]) -> Note? {
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            let js = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let uid = js?["uid"] as! String
            let title = js?["title"] as! String
            let content = js?["content"] as! String
            let color = js?["color"] as! UIColor
            let importance = js?["importance"] as! Importance
            let selfDestructionDate = js?["selfDestructionDate"] as! Date
            let note = Note(uid: uid, title: title, content: content, color: color, selfDestructionDate: selfDestructionDate, importance: importance)
            return note
        } catch {
            return nil
        }
    }
    
    var json: [String: Any] {
        var arrNote = [String: Any]()
        arrNote["uid"] = self.uid
        arrNote["title"] = self.title
        arrNote["content"] = self.content
        if self.color != UIColor.white {
            arrNote["color"] = self.color
        }
        if self.importance != Importance.standart {
            arrNote["importance"] = self.importance
        }
        arrNote["selfDestructionDate"] = self.selfDestructionDate?.timeIntervalSince1970
        return arrNote
    }
}
