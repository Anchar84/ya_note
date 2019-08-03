import UIKit
import Foundation

enum Importance: String {
    case NOT_IMPORTANT
    case ORDINARY
    case IMPORTANT
}

struct Note {
    let uid: String
    let title: String
    let content: String
    let color: UIColor
    let importance: Importance
    let selfDestructionDate: Date?
    
    init (uid: String = UUID().uuidString, title: String, content: String, color: UIColor = UIColor.white, importance: Importance, selfDestructionDate: Date? = nil) {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.importance = importance
        self.selfDestructionDate = selfDestructionDate
    }
}
