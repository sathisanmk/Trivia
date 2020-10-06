//
//  OptionsTableViewCell.swift
//  Trivia
//
//  Created by Sathishkumar Muthukumar on 05/10/20.
//  Copyright © 2020 Sathishkumar Muthukumar. All rights reserved.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkBox: UIImageView!
    @IBOutlet weak var answer: UILabel!
    var questionType = String()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}
