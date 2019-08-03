import UIKit
import Foundation

extension Note {
    static func parse(json: [String: Any]) -> Note? {
        do {
            let test = (json["uid"], json["selfDestructionDate"], json["importance"], json["color"])
            var uid = UUID().uuidString
            var sdd: Date? = nil
            var color = UIColor.white
            var im = Importance.ORDINARY
            switch test {
            case (let id as String, let dt as String?, let imp as String?, let clr as [CGFloat]?):
                uid = id
                if let dt = dt {
                    let fmt = DateFormatter()
                    fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    sdd = fmt.date(from: dt)
                }
                if let imp = imp {
                    im = Importance.init(rawValue: imp)!
                }
                if let clr = clr {
                    color = UIColor(red: clr[0], green: clr[1], blue: clr[2], alpha: clr[3])
                }
            default: break
            }
            
            return Note(uid: uid,
                        title: json["title"] as! String,
                        content: json["content"] as! String,
                        color: color,
                        importance: im,
                        selfDestructionDate: sdd)
            
            
        } catch {
            return nil
        }
    }
    
    var json: [String: Any] {
        var res: [String: Any] = [:]
        res ["uid"] = self.uid
        res ["title"] = self.title
        res ["content"] = self.content
        if (self.importance != .ORDINARY) {
            res ["importance"] = self.importance.rawValue
        }
        if self.selfDestructionDate != nil {
            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
            res ["selfDestructionDate"] = fmt.string(from: self.selfDestructionDate!)
        }
        
        if self.color != UIColor.white {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            
            self.color.getRed(&r, green: &g, blue: &b, alpha: &a)
            res["color"] = [r, g, b, a]
        }
        
        return res
    }
}
