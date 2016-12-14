//
//  NordeaCodingExerciseTests.swift
//  NordeaCodingExerciseTests
//
//  Created by rusko on 12/11/16.
//
//

import XCTest
@testable import NordeaCodingExercise

class VenueServiceMock: VenueService {
    private let venues: [Venue]
    init(venues: [Venue]) {
        self.venues = venues
    }
    override func getVenues(callBack: ([Venue]) -> Void) {
        callBack(venues)
    }
    
}

class VenueViewMock: NSObject, VenueView{
    
    var venues: [CellData] = []
    func setVenues(venues: [CellData]) {
        self.venues = venues
    }
}


class NordeaCodingExerciseTests: XCTestCase {
    
    let noVenues = VenueServiceMock(venues: [])
    let testVenues = VenueServiceMock(venues: [Venue(name:"name1", address: "address1", distance: "distance1"),
                              Venue(name:"name2", address: "address2", distance: "distance2")])
    
    override func setUp() {
        super.setUp()
        Globals.Latitude = "37"
        Globals.Longitude = "-122"
        Globals.VenueQuery = "sushi"
        Globals.ErrorMessage = ""
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCoordinatesMissing(){
        setUp()
        Globals.Latitude = ""
        Globals.Longitude = ""
        let venues = Foursquare.getVenues()
        XCTAssertTrue(venues.isEmpty)
        XCTAssertTrue(Globals.ErrorMessage == "Coordinates missing. Check GPS.")
    }
    
    func testBadKeyword(){
        setUp()
        Globals.Latitude = "37"
        Globals.Longitude = "-122"
        Globals.VenueQuery = "zzzidkkdf"
        let venues = Foursquare.getVenues()
        XCTAssertTrue(venues.isEmpty)
    }
    
    func testSuccessfullFoursquareSearch(){
        setUp()
        let venues = Foursquare.getVenues()
        XCTAssertTrue(!venues.isEmpty)
        XCTAssertTrue(Globals.ErrorMessage.isEmpty)
    }
    
    func testCellDataWhenNoVenuesFound(){
        setUp()
        let venueViewMock = VenueViewMock()
        let venuePresenter = VenuePresenter(venueService: noVenues)
        venuePresenter.attachView(venueViewMock)
        
        venuePresenter.getVenues()
        
        let venueCellDataArray = venueViewMock.venues
        XCTAssertTrue(venueViewMock.venues.count == 1)
        
        let title = venueCellDataArray[0].title
        XCTAssertTrue(title == "0 venues found.")
    }
    
    func testCellDataWhenVenuesFoundSuccessfully(){
        setUp()
        let venueViewMock = VenueViewMock()
        let venuePresenter = VenuePresenter(venueService: testVenues)
        venuePresenter.attachView(venueViewMock)
        
        venuePresenter.getVenues()
        
        let venueCellDataArray = venueViewMock.venues
        XCTAssertTrue(venueViewMock.venues.count == 2)
        
        let title = venueCellDataArray[0].title
        XCTAssertTrue(title == "name1")
    }
    
    func testCellDataWhenErrorIsNotEmpty(){
        Globals.ErrorMessage = "Something went wrong."
        let venueViewMock = VenueViewMock()
        let venuePresenter = VenuePresenter(venueService: testVenues)
        venuePresenter.attachView(venueViewMock)
        
        venuePresenter.getVenues()
        
        let venueCellDataArray = venueViewMock.venues
        print("celldata: \(venueCellDataArray)")
        XCTAssertTrue(venueViewMock.venues.count == 1)
        
        let title = venueCellDataArray[0].title
        XCTAssertTrue(title == "Error")
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
