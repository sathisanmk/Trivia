//
//  AnswersTableViewCell.swift
//  Trivia
//
//  Created by Sathishkumar Muthukumar on 05/10/20.
//  Copyright © 2020 Sathishkumar Muthukumar. All rights reserved.
//

import UIKit

class AnswersTableViewCell: UITableViewCell {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
