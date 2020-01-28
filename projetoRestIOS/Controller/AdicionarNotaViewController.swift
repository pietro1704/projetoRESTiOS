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
			showNilTextAlertController()
			return
		}
		//let note = NoteModel(json: ["title":titleTextField.text!, "content": contentTextField.text!, "date": Date()])
		let note = Attributes(title: titleTextField.text!, content: contentTextField.text!, date: Date())

		
		apiHandler.postNote(note: note)
		
		performSegue(withIdentifier: "unwindToViewNotesSegue", sender: nil)
	}
	
	func showNilTextAlertController(){
		let alert = UIAlertController(title: "Algo Vazio", message: "por favor preencha todos os campos", preferredStyle: .alert)
		let OK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		alert.addAction(OK)
		present(alert, animated: true)
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
