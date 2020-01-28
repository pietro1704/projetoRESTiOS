//
//  NoteModel.swift
//  projetoRestIOS
//
//  Created by Pietro Pugliesi on 28/01/20.
//  Copyright © 2020 Pietro Pugliesi. All rights reserved.
//

import Foundation

struct NoteModel: Decodable{
	var title: String
	var content: String
	var date: Date?
}

