//
//  NoteModel.swift
//  projetoRestIOS
//
//  Created by Pietro Pugliesi on 28/01/20.
//  Copyright © 2020 Pietro Pugliesi. All rights reserved.
//

import Foundation

struct NoteModel: Decodable{
	let id:Int
	var title: String
	var content: String
	var date: Date?
	
	init(json: [String:Any]) {
		id = json["id"] as? Int ?? -1
		title = json["name"] as? String ?? ""
		content = json["content"] as? String ?? ""
		date = json["date"] as? Date

	}
}

