//
//  TestInkUITests.swift
//  TestInkUITests
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import XCTest
import FirebaseAuth
@testable import TestInk

class TestInkUITests: XCTestCase {
  
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoginButton() {
        
        let app = XCUIApplication()
        let logoutButton = app.buttons["Log Out"]
        let tabBarsQuery = app.tabBars
        if tabBarsQuery.buttons["Feed"].exists || tabBarsQuery.buttons["Favorite"].exists {
            tabBarsQuery.buttons["Favorite"].tap()
            logoutButton.tap()
        }
       let loginButton = app.buttons["Login"]
        XCTAssert(loginButton.exists, "The loginVC does not exist")
        
    }
    
    // Turn off connect hardware keyboard in the simulator otherwise this test will fail since this depends on the software keyboard
    func testNavigationBars() {
        
        let app = XCUIApplication()
        let logoutButton = app.buttons["Log Out"]
        let tabBarsQuery = app.tabBars
        
        //First checking where the app is already logged in and is on either feed view or favorite view, if yes, go to favorite view and press logout to get back to login page
        if tabBarsQuery.buttons["Feed"].exists || tabBarsQuery.buttons["Favorite"].exists {
            tabBarsQuery.buttons["Favorite"].tap()
            logoutButton.tap()
        }
        
        let myTextField = app.textFields["Enter email"]
        let exp1 = expectation(for: NSPredicate(format: "hittable == true"), evaluatedWith: myTextField, handler: nil)
        waitForExpectations(timeout: 10.0, handler: nil)
        
        myTextField.tap()
        myTextField.press(forDuration: 1.2)
        
        app.menuItems["Select All"].tap()
      
        // or use app.keys["delete"].tap() if you have keyboard enabled
        app.textFields["Enter email"].typeText("izza.nadeem@yahoo.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("newyork")
        app.buttons["Login"].tap()
        let feedTab = tabBarsQuery.buttons["Feed"]
        
        //waiting for it to login and then tabbar and feedVC to exists, once the feedTab is tapped, it will continue testimg
        let exp = expectation(for: NSPredicate(format: "hittable == true"), evaluatedWith: feedTab, handler: nil)
        waitForExpectations(timeout: 10.0, handler: nil)
        feedTab.tap()
        let feedNav = app.navigationBars["Feed"]
        
        //Testing if the Feed NavigationBar exist
        XCTAssert(feedNav.exists, "The Feed Navigation does not exist")
        tabBarsQuery.buttons["Favorite"].tap()
        let favoriteNav = app.navigationBars["Favorite"]
        
         //Testing if the Favorite NavigationBar exist
        XCTAssert(favoriteNav.exists, "The favorite Nav does not exist")
        tabBarsQuery.buttons["Feed"].tap()
        feedNav.buttons["Add"].tap()
        
        //Testing if the Upload Navigation exist
        let uploadNav = app.navigationBars["Upload"]
        XCTAssert(uploadNav.exists, "The upload nav does not exist")
        
        //testing source Types //ImagePicker
        let addphotoImage = app.images["addphoto"]
        addphotoImage.tap()
        let photoSourceSheet = app.sheets["Photo Source"]
        XCTAssert(photoSourceSheet.exists, "Photo source type does not exist")

        
    }
  

    
}

