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
			showNilTitleAlertController()
			return
		}
		
		guard contentTextField.text != "" else{
			showNilContentAlertController()
			return
		}
		
		let noteTitle = titleTextField.text == "" ? "nota sem título" : titleTextField.text!
		let noteContent = contentTextField.text == "" ? "nota sem conteúdo" : contentTextField.text!

		let note = Attributes(title: noteTitle, content: noteContent, date: Date())

		try? APIHandlerDefault().postNote(note: note)
		
		performSegue(withIdentifier: "unwindToViewNotesSegue", sender: nil)
	}
	
	func showNilTitleAlertController(){
		let alert = UIAlertController(title: "Titulo Vazio", message: "Podemos deixar o título como 'nota sem título'?", preferredStyle: .alert)
		let cancel = UIAlertAction(title: "Voltar", style: .cancel, handler: nil)
		let OK = UIAlertAction(title: "Sim", style: .default){(_)in
			self.titleTextField.text = "nota sem título"
		}
		
		alert.addAction(OK)
		alert.addAction(cancel)
		present(alert, animated: true)
	}
	
	func showNilContentAlertController(){
		let alert = UIAlertController(title: "Conteúdo Vazio", message: "Podemos deixar o conteúdo como 'nota sem conteúdo'?", preferredStyle: .alert)
		let cancel = UIAlertAction(title: "Voltar", style: .cancel, handler: nil)
		let OK = UIAlertAction(title: "Sim", style: .default){(_)in
			self.contentTextField.text = "nota sem conteúdo"
		}
		alert.addAction(OK)
		alert.addAction(cancel)
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
