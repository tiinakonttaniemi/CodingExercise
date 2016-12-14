//
//  Globals.swift
//  NordeaCodingExercise
//
//  Created by rusko on 12/13/16.
//
//

import Foundation

class Globals{
    static var Latitude = ""
    static var Longitude = ""
    static var VenueQuery = ""
    static var ErrorMessage = ""
    
    private static let clientId = "CYEMKOM4OLTP5PHMOFVUJJAMWT5CH5G1JBCYREATW21XLLSZ"
    private static let clientSecret = "GYNP4URASNYRNRGXR5UEN2TGTKJHXY5FGSAXTIHXEUG1GYM2"

    static var ClientId: String {
        get {return clientId}
    }
    static var ClientSecret: String {
        get {return clientSecret}
    }
    
    static func resetErrorMessage(){
        ErrorMessage = ""
    }
    
    static func checkCoordinates()->Bool{
        if Latitude.isEmpty || Longitude.isEmpty {
            ErrorMessage = "Coordinates missing. Check GPS."
            return false
        }
        return true
    }
}