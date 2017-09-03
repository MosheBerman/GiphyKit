//
//  GiphyKitTests.swift
//  GiphyKitTests
//
//  Created by Moshe Berman on 8/29/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import XCTest
@testable import GiphyKit

class GiphyKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Testing the GCD function
    
    func testGCD() {
        let gcdValue = gcd(a: 18, b: 9)
        
        XCTAssertEqual(gcdValue, 9)
    }
    
    func testGCDWithNegativeNumbers()
    {
        let gcdValue = gcd(a: -24, b:-6)
        
        XCTAssertEqual(gcdValue, 6)
    }
    
    func testGCDWithOneNegativeAndOnePositive()
    {
        let gcdValue = gcd(a: -8, b: 4)
        
        XCTAssertEqual(gcdValue, 4)
    }
    
        func testGCDWithBGreaterThanA()
    {
        let gcdValue = gcd(a: 11, b: 44)
        
        XCTAssertEqual(gcdValue, 11)
    }
}
