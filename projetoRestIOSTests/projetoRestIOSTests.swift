//
//  projetoRestIOSTests.swift
//  projetoRestIOSTests
//
//  Created by Pietro Pugliesi on 28/01/20.
//  Copyright © 2020 Pietro Pugliesi. All rights reserved.
//

import XCTest
@testable import projetoRestIOS

class ApiHandlerMock: ApiHandler{
	
	func getAllNotes(completion: @escaping ([JsonObject]) -> Void) {
		let note = Attributes(title: "noteTitle", content: "noteContent", date: Date())
		let jsonObject = JsonObject(type: "type", id: "1", attributes: note, links: Link(link: "10"))
		completion([jsonObject])
	}
	
	func deleteNote(id: String) {
		print("deletei a nota")
	}
	
	func postNote(note: Attributes) {
		print("postei a nota \(note)")
	}
}

class projetoRestIOSTests: XCTestCase {
	var apiHandler:ApiHandlerMock!

	override func setUp() {
		super.setUp()
		apiHandler = ApiHandlerMock()
	}
	
	override func tearDown() {
		apiHandler = nil
		
		super.tearDown()
	}
	
	func testFormatterStringCorrectStyle() {
		let dateNow = Date()
		//mock note
		let note = Attributes(title: "", content: "", date: dateNow)
		
		//srtring from date to check function
		guard let dateStringApp = APIHandlerDefault().formatDate(note) else { return  }
		print("\n\n dateStringApp = \(dateStringApp)\n\n")
		
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm:ss - dd/MM/yyyy"
			
		let dateStringTest = dateFormatter.string(from: dateNow)
		print("\n\n dateStringTest = \(dateStringTest)\n\n")
		XCTAssert(dateStringApp == dateStringTest)
	}
	
	//not nil note but with date nil error
	func testDateNilError() {
		let note = Attributes(title: "", content: "", date: nil)
		XCTAssertNil(APIHandlerDefault().formatDate(note))
	}
	
	func testCreateNote() {
		let note:Attributes!
				
		note = Attributes(title: "titulo", content: "content", date: Date())
		
		XCTAssertNotNil(note)
		
	}
	
	//note not nil but with date nil
	func testNoteNilDate() {
		let note = Attributes(title: "titulo", content: "content", date: nil)
		XCTAssertNotNil(note)

	}
	
	func testGetAll() {
		var json:[JsonObject]!
		
		apiHandler.getAllNotes { (jsonObjects) in
			json = jsonObjects
		}
		
		XCTAssertNotNil(json)
	}
	
	func testGetNoteFromJson() {
		let dateNow = Date()
		let attributes = Attributes(title: "title", content: "content", date: dateNow)
		let json = JsonObject(type: "", id: "", attributes: attributes, links: Link(link: ""))
		
		let note = APIHandlerDefault().getNote(from: [json])
		
		XCTAssert(note[0].title == attributes.title)
		XCTAssert(note[0].content == attributes.content)
		XCTAssert(note[0].date == attributes.date)
	}
}
