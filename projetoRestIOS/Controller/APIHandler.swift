//
//  APIHandler.swift
//  projetoRestIOS
//
//  Created by Pietro Pugliesi on 28/01/20.
//  Copyright © 2020 Pietro Pugliesi. All rights reserved.
//

import Foundation

class APIHandler{
	
	let defaultSession = URLSession(configuration: .default)
	var dataTask:URLSessionTask?
	var errorMessage = ""
	var notes:[NoteModel] = []
	
	typealias JSONDictionary = [String: Any]
	typealias QueryResult = ([NoteModel]?, String) -> Void
	
	func createNote(note: NoteModel){
		print("criei nota \(note)")
	}
	
	
	
	
	func getAllNotes(completion: @escaping QueryResult){
		dataTask?.cancel()
		if var urlComponents = URLComponents(string: "https://projetojs.herokuapp.com/"){
			
			guard let url = urlComponents.url else {
				return
			}
			
			dataTask =
				defaultSession.dataTask(with: url) { [weak self] data, response, error in
					defer {
						self?.dataTask = nil
					}
					// 5
					if let error = error {
						self?.errorMessage += "DataTask error: " +
							error.localizedDescription + "\n"
					} else if
						let data = data,
						let response = response as? HTTPURLResponse,
						response.statusCode == 200 {
						self?.updateSearchResults(data)
						// 6
						DispatchQueue.main.async {
							completion(self?.notes, self?.errorMessage ?? "")
						}
					}
			}
		}
	}
	
	private func updateSearchResults(_ data: Data) {
		var response: JSONDictionary?
		notes.removeAll()
		
		do {
			response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
		} catch let parseError as NSError {
			errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
			return
		}
		
		guard let array = response!["results"] as? [Any] else {
			errorMessage += "Dictionary does not contain results key\n"
			return
		}
		
		var index = 0
		
		for noteDictionary in array {
			if let noteDictionary = noteDictionary as? JSONDictionary,
				let previewURLString = noteDictionary["previewUrl"] as? String,
				let title = noteDictionary["title"] as? String,
				let content = noteDictionary["content"] as? String,
				let date = noteDictionary["date"] as? Date{
				notes.append(NoteModel(title: title, content: content, date: date))
				index += 1
			} else {
				errorMessage += "Problem parsing noteDictionary\n"
			}
		}
	}
}
