//
//  NoteModel.swift
//  projetoRestIOS
//
//  Created by Pietro Pugliesi on 28/01/20.
//  Copyright © 2020 Pietro Pugliesi. All rights reserved.
//

import Foundation

//JsonObject is equal to my JSON (every attribute)
struct JsonObject: Codable {
	var type: String
	var id: String
	var attributes: Attributes
	var links: Link
}

struct Attributes:Codable {
	var title: String
	var content: String
	var date: Date?
}

struct Link: Codable {
	var link:String
}


