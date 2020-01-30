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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
