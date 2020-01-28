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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addRefreshControl()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		#warning("pegar as notas do BD e recarregar a tablw view")
		
		apiHandler.getAllNotes()
	}
	
	@IBAction func unwindToViewNotes(_ unwindSegue: UIStoryboardSegue) {
		let sourceViewController = unwindSegue.source
	}
	
	func addRefreshControl(){
		let refreshControl = UIRefreshControl()
		tableView.refreshControl = refreshControl
	}
}

extension NotasViewController: UITableViewDelegate, UITableViewDataSource{
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
}

