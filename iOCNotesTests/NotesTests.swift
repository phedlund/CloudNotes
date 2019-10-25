//
//  NotesTests.swift
//  iOCNotesTests
//
//  Created by Peter Hedlund on 10/20/19.
//  Copyright © 2019 Peter Hedlund. All rights reserved.
//

import XCTest
@testable import iOCNotes

class NotesTests: XCTestCase {
    var currentServer: String = ""
    var currentUser: String = ""
    var currentPassword: String = ""
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        currentServer = KeychainHelper.server
        currentUser = KeychainHelper.username
        currentPassword = KeychainHelper.password
        
        //Test using a Docker container
        KeychainHelper.server = "http://localhost:8080"
        KeychainHelper.username = "cloudnotes"
        KeychainHelper.password = "cloudnotes"
        
        //Clear database
        CDNote.reset()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        KeychainHelper.server = currentServer
        KeychainHelper.username = currentUser
        KeychainHelper.password = currentPassword
        super.tearDown()
    }

    func testAddNote() {
        let expectation = XCTestExpectation(description: "Note Expectation")
        let content = "Note added during test"
        NotesManager.shared.add(content: content, category: "", completion: { note in
            XCTAssertNotNil(note, "Expected note to not be nil")
            XCTAssertTrue(note?.addNeeded == false, "Expected addNeeded to be false")
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 20.0)
    }

    func testAddNoteWithCategory() {
        let expectation = XCTestExpectation(description: "Note Expectation")
        let content = "Note with category added during test"
        let category = "Test Category"
        NotesManager.shared.add(content: content, category: category, completion: { note in
            XCTAssertNotNil(note, "Expected note to not be nil")
            XCTAssertTrue(note?.addNeeded == false, "Expected addNeeded to be false")
            XCTAssertEqual(note?.category, "Test Category", "Expected the category to be Test Category")
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 20.0)
    }

    func testAddAndDeleteNote() {
        let expectation = XCTestExpectation(description: "Note Expectation")
        let content = "Note added and deleted during test"
        NotesManager.shared.add(content: content, category: "", completion: { note in
            XCTAssertNotNil(note, "Expected note to not be nil")
            XCTAssertTrue(note?.addNeeded == false, "Expected addNeeded to be false")
            if let note = note {
                NotesManager.shared.delete(note: note) {
                    expectation.fulfill()
                }
            }
        })
        wait(for: [expectation], timeout: 25.0)
    }

    func testAddAndDeleteNoteWithCategory() {
        let expectation = XCTestExpectation(description: "Note Expectation")
        let content = "Note added and deleted during test"
        let category = "Test Category"
        NotesManager.shared.add(content: content, category: category, completion: { note in
            XCTAssertNotNil(note, "Expected note to not be nil")
            XCTAssertTrue(note?.addNeeded == false, "Expected addNeeded to be false")
            XCTAssertEqual(note?.category, "Test Category", "Expected the category to be Test Category")
            if let note = note {
                NotesManager.shared.delete(note: note) {
                    expectation.fulfill()
                }
            }
        })
        wait(for: [expectation], timeout: 25.0)
    }

    func testAddOffline() {
        let expectation = XCTestExpectation(description: "Note Expectation")
        KeychainHelper.offlineMode = true
        let content = "Note added during offline test"
        NotesManager.shared.add(content: content, category: "", completion: { note in
            XCTAssertNotNil(note, "Expected note to not be nil")
            XCTAssertTrue(note?.addNeeded == true, "Expected addNeeded to be true")
            KeychainHelper.offlineMode = false
            NotesManager.shared.sync() {
                if CDNote.all()?.filter( { $0.addNeeded == true }).count ?? 0 > 0 {
                    XCTFail("Expected addNeeded count to be 0")
                }
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 25.0)
    }


}
