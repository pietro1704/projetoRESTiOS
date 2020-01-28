//
//  APIHandler.swift
//  projetoRestIOS
//
//  Created by Pietro Pugliesi on 28/01/20.
//  Copyright © 2020 Pietro Pugliesi. All rights reserved.
//

import Foundation

class APIHandler{
	
	func getAllNotes(completion: @escaping (_ note:[JsonObject])->Void) {
		guard let url = URL(string: "https://projetojs.herokuapp.com/") else{return}
		
		
		let session = URLSession.shared
		session.dataTask(with: url) { (data, response, error) in
			if let response = response{
				print(response)
			}
			
			if let data = data{
				print("DATA = ",data)
				do{
					let notes = try JSONDecoder().decode([JsonObject].self, from: data)
					
					completion(notes)
					
				}catch{
					print(error)
				}
			}
		}.resume()
	}
	
	func postNote(note: Attributes) {
		let parameters = ["title": note.title, "content": note.content, "date": note.date]
		
		guard let url = URL(string: "https://projetojs.herokuapp.com/") else{return}
		
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else{
			return
		}
		request.httpBody = httpBody
		
		let session = URLSession.shared
		session.dataTask(with: request) { (data, respose, error) in
			if let data = data{
				do{
					let json = try JSONSerialization.jsonObject(with: data, options: [])
					print(json)
				}catch{
					print(error)
				}
			}
		}.resume()
	}
}

