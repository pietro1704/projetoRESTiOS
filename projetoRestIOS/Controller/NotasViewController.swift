//
//  ViewController.swift
//  projetoRestIOS
//
//  Created by Pietro Pugliesi on 28/01/20.
//  Copyright © 2020 Pietro Pugliesi. All rights reserved.
//

import UIKit

class NotasViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	let apiHandler = APIHandlerDefault()
	
	var emptyTableViewLabel = UILabel()
	
	var notes:[Attributes] = [] //note list (json title, content and date attributes only)
	
	var activityIndicator = UIActivityIndicatorView()
	
	var jsonObjects:[JsonObject] = [] {//json objects stored in database
		didSet{
			
			//updates note list (json title, content and date attributes only)
			self.notes = apiHandler.getNote(from: jsonObjects)
			
		}
	}
	
	fileprivate func configureItensEmptyNotes() {
		if self.jsonObjects.count == 0{
			
			
			//hides table view if empty
			self.tableView.isHidden = true
			
			//sets empty table view label to appear only when activity indicator is hidden
			if self.activityIndicator.isAnimating == false{
				self.emptyTableViewLabel.isHidden = false
				
			}
		}else{
			//hides empty table view label and shows table view
			self.emptyTableViewLabel.isHidden = true
			self.tableView.isHidden = false
			
		}
	}
	
	fileprivate func configureActivityIndicator() {
		activityIndicator.hidesWhenStopped = true
		activityIndicator.style = .large
		activityIndicator.center = self.view.center
		self.view.addSubview(activityIndicator)
	}
	
	func addRefreshControl(){
		let refreshControl = UIRefreshControl()
		
		refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
		tableView.refreshControl = refreshControl
	}
	
	@objc func refreshData(_ sender:Any){
		updateTableView()
		tableView.refreshControl?.endRefreshing()
	}
	
	fileprivate func configureEmptyTableViewLabel() {
		emptyTableViewLabel.frame = self.view.frame
		emptyTableViewLabel.adjustsFontForContentSizeCategory = true
		emptyTableViewLabel.numberOfLines = 0
		emptyTableViewLabel.text = "Você ainda não tem nenhuma nota..."
		emptyTableViewLabel.textAlignment = .center
		emptyTableViewLabel.font = UIFont.preferredFont(forTextStyle: .title2)
		self.view.addSubview(emptyTableViewLabel)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.isHidden = true
		emptyTableViewLabel.isHidden = true
		
		configureEmptyTableViewLabel()
		
		//activity indicator and table view refresh control
		configureActivityIndicator()
		addRefreshControl()
	}
	
	//api get all notes asyncronously, configure jsonObjects and notes and reload table view
	fileprivate func updateTableView() {
		self.activityIndicator.startAnimating()
		apiHandler.getAllNotes { (jsons) in
			self.jsonObjects = jsons
			
			DispatchQueue.main.async {
				self.activityIndicator.stopAnimating()
				self.tableView.reloadData()
				self.configureItensEmptyNotes()
			}
		}
	}
	
	//load or unwind here or back
	override func viewDidAppear(_ animated: Bool) {
		//no super bc it changes subview appearance behaviour
		self.emptyTableViewLabel.isHidden = true
		updateTableView()
	}
	
	@IBAction func unwindToViewNotes(_ unwindSegue: UIStoryboardSegue) {}
	
}


extension NotasViewController: UITableViewDelegate, UITableViewDataSource{
	
	//number of rows
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return jsonObjects.count
	}
	
	//cell for row at
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NotasTableViewCell
		
		let note = notes[indexPath.row]
		cell.titleLabel.text = note.title
		cell.dateLabel.text = apiHandler.formatDate(note)
		
		return cell
	}
	
	//swipe editing style. Automatic for left to right languages
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete{
			apiHandler.deleteNote(id: jsonObjects[indexPath.row].id)
			jsonObjects.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
			
			//reload data
			updateTableView()
		}
	}
	
	//select cell
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.performSegue(withIdentifier: "toViewNote", sender: notes[indexPath.row])
	}
	
	//loads cell view when selected
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let sender = sender as? Attributes else{return}
		guard let dest = segue.destination as? ViewNoteViewController else {return}
		dest.note = sender
	}
}

