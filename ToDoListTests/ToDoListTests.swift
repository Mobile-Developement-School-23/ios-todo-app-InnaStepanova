//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Лаванда on 16.06.2023.
//

import XCTest
@testable import ToDoList

final class ToDoListTests: XCTestCase {
    
    var sut: TodoItem!
    
    let id = "id"
    let text = "Test"
    let importance = Importance.normal
    let deadline = Date()
    let isDone = false
    let created = Date()
    let changed = Date()
    
    override func setUp() {
        super.setUp()
        
        sut = TodoItem(id: id,
                       text: text,
                       importance: importance,
                       deadline: deadline,
                       isDone: isDone,
                       created: created,
                       changed: changed)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    
    func testGenerateIdIfNotSpecified() {
        
        let todoItem = TodoItem(text: text,
                                importance: importance,
                                deadline: deadline,
                                isDone: isDone,
                                created: created,
                                changed: changed)
        
        XCTAssertNotNil(todoItem)
    }
    
    func testInit() {
        
        XCTAssertEqual(sut.id, id)
        XCTAssertEqual(sut.text, text)
        XCTAssertEqual(sut.importance, importance)
        XCTAssertEqual(sut.deadline, deadline)
        XCTAssertEqual(sut.isDone, isDone)
        XCTAssertEqual(sut.created, created)
        XCTAssertEqual(sut.changed, changed)
    }

    func testInitNoDeadline() {
      
        let todoItem = TodoItem(id: id,
                                text: text,
                                importance: importance,
                                isDone: isDone,
                                created: created,
                                changed: changed)
        
        XCTAssertNil(todoItem.deadline)
    }

    func testInitNoChanged() {
        
        let todoItem = TodoItem(id: id,
                                text: text,
                                importance: importance,
                                deadline: deadline,
                                isDone: isDone,
                                created: created)
        
        XCTAssertNil(todoItem.changed)
    }
    
    func testJsonCreated() {
        
        let todoItem = TodoItem(id: id,
                                text: text,
                                importance: .high,
                                deadline: deadline,
                                isDone: isDone,
                                created: created,
                                changed: changed)
        
        let json = todoItem.json
        XCTAssertTrue(json is [String: Any])
        
        let dict = json as! [String: Any]
        XCTAssertEqual(dict["id"] as? String, id)
        XCTAssertEqual(dict["text"] as? String, text)
        XCTAssertEqual(dict["importance"] as? String, Importance.high.rawValue)
        XCTAssertEqual(dict["isDone"] as? Bool, isDone)
        XCTAssertEqual(dict["created"] as? TimeInterval, created.timeIntervalSince1970)
        XCTAssertEqual(dict["changed"] as? TimeInterval, changed.timeIntervalSince1970)
        XCTAssertEqual(dict["deadline"] as? TimeInterval, deadline.timeIntervalSince1970)
    }
    
    func testIfImportanceNormalNotWriteInJson() {
        let json = sut.json
        let dict = json as! [String: Any]
        XCTAssertNil(dict["importance"])
    }
    func testIfImportanceNotNormalItWriteInJson() {
        let importance = Importance.high
        let todoItem = TodoItem(id: id,
                                text: text,
                                importance: .high,
                                deadline: deadline,
                                isDone: isDone,
                                created: created,
                                changed: changed)
        let json = todoItem.json
        let dict = json as! [String: Any]
        XCTAssertEqual(dict["importance"] as? String, importance.rawValue)
    }
    
    func testParceJsonIfBasicPropertiesNotSet() {
        var dict = [String: Any]()
        dict["id"] = nil
        dict["text"] = nil
        dict["importance"] = nil
        dict["isDone"] = nil
        dict["created"]  = nil
        dict["changed"] = changed.timeIntervalSince1970
        dict["deadline"] = deadline.timeIntervalSince1970
        XCTAssertNil(TodoItem.parse(json: dict))
    }
    
    func testParseJson() {
        let json = sut.json
        let todoItem = TodoItem.parse(json: json)
        XCTAssertEqual(todoItem?.id, sut.id)
        XCTAssertEqual(todoItem?.text, sut.text)
        XCTAssertEqual(todoItem?.importance, sut.importance)
        XCTAssertEqual(todoItem?.isDone, sut.isDone)
        XCTAssertEqual(todoItem?.created, sut.created)
        XCTAssertEqual(todoItem?.changed, sut.changed)
        XCTAssertEqual(todoItem?.deadline, sut.deadline)
    }
    
    func testParseJsonIfImportanceNotSet() {
        var dict = [String: Any]()
        dict["id"] = id
        dict["text"] = text
        dict["importance"] = nil
        dict["isDone"] = isDone
        dict["created"]  = created.timeIntervalSince1970
        dict["changed"] = changed.timeIntervalSince1970
        dict["deadline"] = deadline.timeIntervalSince1970
        
        let todoItem = TodoItem.parse(json: dict)
        
        XCTAssertEqual(todoItem?.importance, Importance.normal)
    }
    
    func testParseIfChangedAndDeadlineNotSet() {
        var dict = [String: Any]()
        dict["id"] = id
        dict["text"] = text
        dict["importance"] = importance
        dict["isDone"] = isDone
        dict["created"]  = created.timeIntervalSince1970
        dict["changed"] = nil
        dict["deadline"] = nil
        
        let todoItem = TodoItem.parse(json: dict)
        
        XCTAssertNil(todoItem?.deadline)
        XCTAssertNil(todoItem?.changed)
    }
    func testParseCSVvaluesNotEqualTo7() {
        let csv = "1, 2, 3, 4"
        XCTAssertNil(TodoItem.parse(csv: csv))
    }
    
    func testParseCSVImportanseNotSet() {
        let csv = "id,Text,,16/06/2023 23:42:43,true,16/06/2023 23:42:43,16/06/2023 23:42:43"
        let todoItem = TodoItem.parse(csv: csv)
        XCTAssertEqual(todoItem?.importance, Importance.normal)
    }
    
    func testParceCSVIsDoneNotSet() {
        let csv = "id,Text,,16/06/2023 23:42:43,,16/06/2023 23:42:43,16/06/2023 23:42:43"
        let todoItem = TodoItem.parse(csv: csv)
        XCTAssertNil(todoItem)
    }
    
    func testParceCSVCreatedNotSet() {
        let csv = "id,Text,high,,true,,"
        let todoItem = TodoItem.parse(csv: csv)
        XCTAssertNil(todoItem)
    }
    
    func testParceCSVCreatedVrongFormat() {
        let csv = "id,Text,high,,true,16/06/2023 23:,16/06/2023 23:42:43"
        let todoItem = TodoItem.parse(csv: csv)
        XCTAssertNil(todoItem)
    }
    
}
