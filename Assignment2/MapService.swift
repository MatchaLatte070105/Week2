import Foundation
import MapKit
import CoreLocation

class MapService {
    static func getRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping (Double, Double, MKRoute?) -> Void) {
        let request = MKDirections.Request()
        
        let sourceLocation = CLLocation(latitude: source.latitude, longitude: source.longitude)
        let destinationLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        
        request.source = MKMapItem(location: sourceLocation, address: nil)
        request.destination = MKMapItem(location: destinationLocation, address: nil)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first {
                let distanceKm = route.distance / 1000.0
                let timeMinutes = route.expectedTravelTime / 60.0
                completion(distanceKm, timeMinutes, route)
            } else {
                completion(0.0, 0.0, nil)
            }
        }
    }
}
