//
//  VenueService.swift
//  NordeaCodingExercise
//
//  Created by rusko on 12/12/16.
//

import Foundation

class VenueService{
    
    
    func getVenues(callBack:([Venue]) -> Void){
//        let venues = [Venue(name:"name1", address: "address1", distance: "distance1"),
//                      Venue(name:"name2", address: "address2", distance: "distance2")
//        ]
        let venues = Foursquare.getVenues()

        callBack(venues)
    }
}