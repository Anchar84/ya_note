//
//  NoteViewCell.swift
//  Notes
//
//  Created by user on 21.07.2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class NoteViewCell: UITableViewCell {

    
    @IBOutlet weak var noteColor: UIView!
    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteTextLabel: UILabel!
    //    @IBOutlet weak var noteColor: UIView!
//    @IBOutlet weak var noteTitleLabel: UILabel!
//    @IBOutlet weak var noteTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        noteColor.layer.borderWidth = 1
        noteColor.layer.borderColor = UIColor.gray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
