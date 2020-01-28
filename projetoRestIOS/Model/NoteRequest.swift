//
//  NoteRequest.swift
//  projetoRestIOS
//
//  Created by Pietro Pugliesi on 28/01/20.
//  Copyright © 2020 Pietro Pugliesi. All rights reserved.
//

import Foundation


enum NoteError:Error{
	case noDataAvailable
	case canNotProcessData
}


struct NoteRequest {
	var resourceURL:URL
	
	init(noteID:String) {
		let resourceString = "projetojs.herokuapp.com"
		
		guard let resourceURL = URL(string: resourceString)else{fatalError()}
		
		self.resourceURL = resourceURL
	}
	
	func getNotes(completion: @escaping(Result<[NoteModel], NoteError>)->Void){
		
	}
}
