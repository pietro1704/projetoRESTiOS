//
//  ViewNoteViewController.swift
//  projetoRestIOS
//
//  Created by Pietro Pugliesi on 29/01/20.
//  Copyright © 2020 Pietro Pugliesi. All rights reserved.
//

import UIKit

class ViewNoteViewController: UIViewController {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var contentLabel: UILabel!
	
	var note:Attributes?

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		titleLabel.text = note?.title
		dateLabel.text = APIHandler().formatDate(note)
		contentLabel.text = note?.content
	}
}
