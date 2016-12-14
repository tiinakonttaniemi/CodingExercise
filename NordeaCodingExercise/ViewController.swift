//
//  ViewController.swift
//  NordeaCodingExercise
//
//  Created by rusko on 12/11/16.
//
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var venueTextField: UITextField?
    @IBOutlet weak var foundVenuesTableView: UITableView?
    
    private var venuePresenter: VenuePresenter?
    private var venuesToDisplay: [CellData] = []
    private var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initLocationManager()
        
        venueTextField?.delegate = self
        foundVenuesTableView?.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func initLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let locValue = manager.location?.coordinate
        print("locations = \(locValue?.latitude), \(locValue?.longitude)")
        setCoordinates(locValue?.latitude, longitude: locValue?.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        locationManager.startUpdatingLocation()
        textField.addTarget(self, action: #selector(ViewController.textFieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    func textFieldDidChange(textField: UITextField){
        setVenueQuery(textField)
        updateVenuesInTapleView()
    }
    
    func setVenueQuery(textField: UITextField){
        if let textString = textField.text{
            Globals.VenueQuery = textString
        }
    }
    
    func updateVenuesInTapleView(){
        venuePresenter = VenuePresenter(venueService: VenueService())
        venuePresenter?.attachView(self)
        venuePresenter?.getVenues()
    }
    
    func setCoordinates(latitude: Double?, longitude: Double?){
        if let latitudeDouble = latitude{
            Globals.Latitude = String(format: "%f", latitudeDouble)
        }
        if let longitudeDouble = longitude {
            Globals.Longitude = String(format: "%f", longitudeDouble)
        }
        print("Globals latitude: \(Globals.Latitude), longitude: \(Globals.Longitude)")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        venueTextField?.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venuesToDisplay.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "UserCell")
        let cellData = venuesToDisplay[indexPath.row]
        cell.textLabel?.text = cellData.title
        cell.detailTextLabel?.text = cellData.details
        cell.textLabel
        return cell
    }
    
}

extension ViewController: VenueView {
    
    func setVenues(venues: [CellData]) {
        venuesToDisplay = venues
        foundVenuesTableView?.reloadData()
    }
}