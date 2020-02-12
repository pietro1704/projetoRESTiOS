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
			#warning("Handle error.....")
			print("note ainda nil")
			return nil
		}
		
		guard note?.date != nil else{
			#warning("Handle error.....")

			print("date nil")
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
		guard let url = URL(string: "https://projetojs.herokuapp.com/notes") else{
			#warning("Handle error.....")
			return
		}
		
		//url session
		let session = URLSession.shared
		session.dataTask(with: url) { (data, response, error) in
			
			if let data = data{
				do{
					let jsonDecoder = JSONDecoder()
					
					//my dateFormatterExtension for formatting JSON iso8601 date
					jsonDecoder.dateDecodingStrategy = .formatted(.fullISO8601)
					let notes = try jsonDecoder.decode([JsonObject].self, from: data)
					
					completion(notes)
					
				}catch{
					#warning("Handle error.....")

					print("erro no getAll", error.localizedDescription)
				}
			}
		}.resume()
	}
	
	//delete note provided its id
	func deleteNote(id:String){
		guard let url = URL(string: "https://projetojs.herokuapp.com/notes/\(id)") else{
			#warning("Handle error.....")
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "DELETE"
		
		URLSession.shared.dataTask(with: request) { (data, respose, error) in
			DispatchQueue.main.async {
				if let error = error{
					#warning("Handle error.....")

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
			#warning("Handle error.....")

			return
		}
		request.httpBody = httpBody
		
		let session = URLSession.shared
		session.dataTask(with: request) { (data, respose, error) in
			if let error = error{
				#warning("Handle error.....")

				print("erro no Post",error.localizedDescription)
			}
		}.resume()
	}
}

