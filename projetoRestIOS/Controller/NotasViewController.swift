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
	var jsonObjects:[JsonObject]?
	var notes:[Attributes]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addRefreshControl()
	}
	
	fileprivate func updateTableView() {
		apiHandler.getAllNotes { (jsons) in
			self.jsonObjects = jsons
			self.notes = jsons.map{$0.attributes}
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
			
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		#warning("pegar as notas do BD e recarregar a tablw view")
		
		updateTableView()
	}
	
	
	
	@IBAction func unwindToViewNotes(_ unwindSegue: UIStoryboardSegue) {
		let sourceViewController = unwindSegue.source
	}
	
	func addRefreshControl(){
		let refreshControl = UIRefreshControl()
		
		refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
		tableView.refreshControl = refreshControl
	}
	
	@objc func refreshData(_ sender:Any){
		updateTableView()
//		tableView.reloadData()
		tableView.refreshControl?.endRefreshing()
	}
}

extension NotasViewController: UITableViewDelegate, UITableViewDataSource{
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notes?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NotasTableViewCell
		
		let note = notes![indexPath.row]
		cell.titleLabel.text = note.title
		cell.dateLabel.text = apiHandler.formatDate(note)
		
		return cell
	}
	
	
}

