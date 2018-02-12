//
//  SurveyTableViewCell.swift
//  GPO
//
//  Created by Руслан Ахриев on 02.11.2017.
//  Copyright © 2017 Руслан Ахриев. All rights reserved.
//

import UIKit

class SurveyTableViewCell: UITableViewCell {


    @IBOutlet weak var surveyTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
