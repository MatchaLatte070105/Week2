import Foundation
import CoreLocation

class Restaurant: Identifiable {
    let id = UUID()
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, address: String, latitude: Double, longitude: Double) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}

class Order: Identifiable {
    let id = UUID()
    var restaurant: Restaurant
    var customerName: String
    var deliveryAddress: String
    var latitude: Double
    var longitude: Double
    var status: String
    
    init(restaurant: Restaurant, customerName: String, deliveryAddress: String, latitude: Double, longitude: Double, status: String = "Pending") {
        self.restaurant = restaurant
        self.customerName = customerName
        self.deliveryAddress = deliveryAddress
        self.latitude = latitude
        self.longitude = longitude
        self.status = status
    }
}
