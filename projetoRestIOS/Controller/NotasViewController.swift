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
	
	let apiHandler = APIHandler()
	
	var jsonObjects:[JsonObject]?{
		didSet{
			if jsonObjects?.count == 0{//hides table view if empty
				tableView.isHidden = true
			}else{
				tableView.isHidden = false
			}
		}
	}
	
	var notes:[Attributes]?
	
	var activityIndicator = UIActivityIndicatorView()
	
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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.isHidden = true
		
		//activity indicator and table view refresh control
		configureActivityIndicator()
		addRefreshControl()
	}
	
	//api get all notes asyncronously, configure jsonObjects and notes and reload table view
	fileprivate func updateTableView() {
		apiHandler.getAllNotes { (jsons) in
			self.jsonObjects = jsons
			self.notes = jsons.map{$0.attributes}

			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	//animates activity indicator and remove it when table view loaded
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		activityIndicator.startAnimating()
		
		updateTableView()
	}
	
	//animates activity indicator and remove it when table view loaded
	@IBAction func unwindToViewNotes(_ unwindSegue: UIStoryboardSegue) {
		activityIndicator.startAnimating()
		
		updateTableView()
	}
}


extension NotasViewController: UITableViewDelegate, UITableViewDataSource{
	
	//number of rows
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notes?.count ?? 0
	}
	
	//cell for row at
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NotasTableViewCell
		
		let note = notes![indexPath.row]
		cell.titleLabel.text = note.title
		cell.dateLabel.text = apiHandler.formatDate(note)
		
		activityIndicator.stopAnimating()
		
		return cell
	}
	
	//swipe editing stylw. Automatic for left to right languages
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete{
			apiHandler.deleteNote(id: jsonObjects![indexPath.row].id)
			notes?.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
			updateTableView()
			
		}
	}
	
	//select cell
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.performSegue(withIdentifier: "toViewNote", sender: notes![indexPath.row])
	}
	
	//loads cell view when selected
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let sender = sender as? Attributes else{return}
		guard let dest = segue.destination as? ViewNoteViewController else {return}
		dest.note = sender
	}
}

