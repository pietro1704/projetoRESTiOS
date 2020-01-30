//
//  APIHandler.swift
//  projetoRestIOS
//
//  Created by Pietro Pugliesi on 28/01/20.
//  Copyright © 2020 Pietro Pugliesi. All rights reserved.
//

import Foundation

protocol ApiHandler {
	func getAllNotes(completion: @escaping (_ note:[JsonObject])->Void)
	func deleteNote(id:String)
	func postNote(note: Attributes)
}

class APIHandlerDefault: ApiHandler{
	
	//format date from note as string: "HH:mm:ss - dd/MM/yyyy"
	func formatDate(_ note: Attributes?)->String? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm:ss - dd/MM/yyyy"
		dateFormatter.timeZone = .current
		
		guard note != nil else{
			print("note ainda nil")
			return nil
		}
		
		let date = dateFormatter.string(from: (note?.date)!)
		
		return date
	}
	
	//getNoteFromJson
	func getNote(from jsonObj:[JsonObject])->[Attributes]{
		return jsonObj.map{$0.attributes}
	}
		
	//get all notes from app url and executes completion assyncronously
	func getAllNotes(completion: @escaping (_ note:[JsonObject])->Void) {
		guard let url = URL(string: "https://projetojs.herokuapp.com/notes") else{return}
		
		//url session
		let session = URLSession.shared
		session.dataTask(with: url) { (data, response, error) in
			
			if let data = data{
				do{
					let jsonDecoder = JSONDecoder()
					jsonDecoder.dateDecodingStrategy = .formatted(.fullISO8601)
					let notes = try jsonDecoder.decode([JsonObject].self, from: data)
					
					completion(notes)
					
				}catch{
					print("erro no getAll", error.localizedDescription)
				}
			}
		}.resume()
	}
	
	//delete note provided its id
	func deleteNote(id:String){
		guard let url = URL(string: "https://projetojs.herokuapp.com/notes/\(id)") else{return}
		
		var request = URLRequest(url: url)
		request.httpMethod = "DELETE"
		
		URLSession.shared.dataTask(with: request) { (data, respose, error) in
			DispatchQueue.main.async {
				if let error = error{
					print("erro no delete", error.localizedDescription)
					return
				}
				
			}
		}.resume()
	}
	
	//posts note
	func postNote(note: Attributes) {
		let parameters = ["title": note.title, "content": note.content]
		
		guard let url = URL(string: "https://projetojs.herokuapp.com/notes") else{return}
		
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else{
			return
		}
		request.httpBody = httpBody
		
		let session = URLSession.shared
		session.dataTask(with: request) { (data, respose, error) in
			if let error = error{
				print("erro no Post",error.localizedDescription)
			}
		}.resume()
	}
}

