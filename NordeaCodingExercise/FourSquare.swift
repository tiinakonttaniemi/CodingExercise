//
//  FourSquare.swift
//  NordeaCodingExercise
//
//  Created by rusko on 12/13/16.
//
//

import Foundation

class Foursquare{
    
    static func getVenues()->[Venue]{
        if Globals.checkCoordinates(){
            let respJson = searchVenues()
            return createVenues(respJson)
        }
        return []
    }
    private static func searchVenues()->JSON{
        var responseJson = JSON([:])
        
        let semaphore = dispatch_semaphore_create(0)
        let httpGet = "https://api.foursquare.com/v2/venues/search?client_id=\(Globals.ClientId)&client_secret=\(Globals.ClientSecret)&v=20130815&ll=\(Globals.Latitude),\(Globals.Longitude)&query=\(Globals.VenueQuery)"
        let escapedHttpGet = httpGet.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        let request = NSMutableURLRequest(URL: NSURL(string: escapedHttpGet!)!)
        request.HTTPMethod = "GET"
        request.timeoutInterval = 0.5
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request, completionHandler:
            {
                data, response, error -> Void in
                
                if(error != nil) {
                    print(error!.localizedDescription)
                    Globals.ErrorMessage = error!.localizedDescription
                    
                }
                else{
                    var parsingError: NSError?
                    
                    responseJson = JSON(data: data!, error: &parsingError)
                    Globals.resetErrorMessage()
                    
                }
                dispatch_semaphore_signal(semaphore)
        })
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        return responseJson

    }
    
    private static func createVenues(json:JSON)-> [Venue]{
        var venues: [Venue] = []
        if let venuesArray = json["response", "venues"].array{
            for venue in venuesArray{
                print("name: \(venue["name"]), address: \(venue["location", "address"]), distance: \(venue["location", "distance"]) ")
                let venueName = "\(venue["name"])"
                let venueAddress = "\(venue["location", "address"])"
                let venueDistance = "\(venue["location", "distance"])"
                venues.append(Venue(name: venueName, address: venueAddress, distance: venueDistance))
                
            }
        }
        
        return venues
    }
    
}
