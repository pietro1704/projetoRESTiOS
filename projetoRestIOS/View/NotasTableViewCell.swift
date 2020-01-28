//
//  NotasTableViewCell.swift
//  projetoRestIOS
//
//  Created by Pietro Pugliesi on 28/01/20.
//  Copyright © 2020 Pietro Pugliesi. All rights reserved.
//

import UIKit

class NotasTableViewCell: UITableViewCell {
	
	var note:Attributes?
	
	var apiHandler = APIHandler()
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		titleLabel.text = note?.title
		dateLabel.text = apiHandler.formatDate(note)
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
