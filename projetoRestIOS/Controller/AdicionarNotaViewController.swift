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
		
	override func viewDidLoad() {
		super.viewDidLoad()
		
		titleTextField.delegate = self
		contentTextField.delegate = self
		
	}
	
	@IBAction func adicionarTapped(_ sender: Any) {
		guard titleTextField.text != "" else{
			showNilTextAlertController()
			return
		}
		let note = Attributes(title: titleTextField.text!, content: contentTextField.text!, date: Date())

		APIHandlerDefault().postNote(note: note)
		
		performSegue(withIdentifier: "unwindToViewNotesSegue", sender: nil)
	}
	
	func showNilTextAlertController(){
		let alert = UIAlertController(title: "Titulo Vazio", message: "por favor preencha o título", preferredStyle: .alert)
		let OK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		alert.addAction(OK)
		present(alert, animated: true)
	}
}

extension AdicionarNotaViewController: UITextFieldDelegate{
	//remove keyboard
	func textFieldDidEndEditing(_ textField: UITextField) {
		textField.resignFirstResponder()
	}
	
	//accepts enter and remove keyboard
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
