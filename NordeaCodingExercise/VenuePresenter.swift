//
//  VenuePresenter.swift
//  NordeaCodingExercise
//
//  Created by rusko on 12/12/16.
//
//

import Foundation

struct CellData {
    let title: String
    let details: String
}

protocol VenueView: NSObjectProtocol {
    func setVenues(venues: [CellData])
}

class VenuePresenter{
    private let venueService: VenueService
    weak private var venueView: VenueView?
    
    init(venueService: VenueService){
        self.venueService = venueService
    }
    
    func attachView(view: VenueView){
        venueView = view
    }
    
    func detachView(){
        venueView = nil
    }
    
    func getVenues(){
        venueService.getVenues{ [weak self] venues in
            var cellData: [CellData] = []
            if !Globals.ErrorMessage.isEmpty {
                cellData = [CellData(title: "Error", details: Globals.ErrorMessage)]
            }
            else if venues.count == 0{
                cellData = [CellData(title:"0 venues found.", details: "Try some other keyword.")]
            }
            else{
                cellData = venues.map{
                    return CellData(title: "\($0.name)", details: "addr:\($0.address), distance:\($0.distance)m")
                }
            }
            self?.venueView?.setVenues(cellData)
        }
    }
}