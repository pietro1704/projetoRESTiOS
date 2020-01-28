//
//  AdicionarNotaViewController.swift
//  projetoRestIOS
//
//  Created by Pietro Pugliesi on 28/01/20.
//  Copyright © 2020 Pietro Pugliesi. All rights reserved.
//

import UIKit

class AdicionarNotaViewController: UIViewController {
	
	@IBOutlet weak var titleTextField: UITextField!
	
	@IBOutlet weak var contentTextField: UITextField!
	
	let apiHandler = APIHandler()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		titleTextField.delegate = self
		contentTextField.delegate = self
		
	}
	
	@IBAction func adicionarTapped(_ sender: Any) {
		guard titleTextField.text != "", contentTextField.text != "" else{
			print("algum texto vazio")
			return
		}
		let note = NoteModel(title: titleTextField.text!, content: contentTextField.text!, date: Date())
		apiHandler.createNote(note: note)
	}
}

extension AdicionarNotaViewController: UITextFieldDelegate{
	func textFieldDidEndEditing(_ textField: UITextField) {
		textField.resignFirstResponder()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
