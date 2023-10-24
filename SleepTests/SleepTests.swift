//
//  SleepTrackerTests.swift
//  SleepTrackerTests
//
//  Created by apple on 24/10/23.
//

@testable import Sleep
import XCTest

class SleepTests: XCTestCase {

    // Test if the function fetchIPAddress successfully fetches an IP address.
    // Given the dependency on an external API, this test will essentially
    // check if the API's response contains a valid IP format.
    func testIPAddressFetching() {
        let contentView = ContentView()
        
        let expectation = self.expectation(description: "Fetching IP Address")
        
        contentView.fetchIPAddress()
        
        // Provide ample time for the network request to complete.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if let ipAddress = contentView.ipAddress {
                // Check if the IP address is in a valid format (simple regex for IP validation)
                let ipPattern = "^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$"
                XCTAssertTrue(ipAddress.range(of: ipPattern, options: .regularExpression) != nil, "Invalid IP format")
            } else {
                XCTFail("Failed to fetch IP address.")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    // Test if the SleepData's duration calculation is accurate.
    // This will ensure that the time difference between the wakeTime and sleepTime
    // is calculated correctly, which is essential for accurate reporting.
    func testSleepDataDurationCalculation() {
        let sleepTime = Date()
        let wakeTime = sleepTime.addingTimeInterval(8*3600) // 8 hours later
        let sleepData = SleepData(date: Date(), sleepTime: sleepTime, wakeTime: wakeTime)
        
        // The expected duration is 8 hours, so we check if it matches.
        XCTAssertEqual(sleepData.duration, 8.0, accuracy: 0.01, "Sleep duration calculation is inaccurate.")
    }

}
