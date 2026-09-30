import SwiftUI

struct AddOrderView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var orders: [Order]
    
    @State private var restaurantName = ""
    @State private var restaurantAddress = ""
    @State private var customerName = ""
    @State private var deliveryAddress = ""
    @State private var customerLat = ""
    @State private var customerLng = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Restaurant Details")) {
                    TextField("Restaurant Name", text: $restaurantName)
                    TextField("Restaurant Address", text: $restaurantAddress)
                }
                
                Section(header: Text("Customer & Route Details")) {
                    TextField("Customer Name", text: $customerName)
                    TextField("Delivery Address", text: $deliveryAddress)
                    TextField("Latitude (e.g., 10.7850)", text: $customerLat)
                        .keyboardType(.decimalPad)
                    TextField("Longitude (e.g., 106.6780)", text: $customerLng)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add New Order")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        addNewOrder()
                        dismiss()
                    }
                    .disabled(restaurantName.isEmpty || customerName.isEmpty)
                }
            }
        }
    }
    
    private func addNewOrder() {
        let lat = Double(customerLat) ?? 10.7780
        let lng = Double(customerLng) ?? 106.6790
        
        let newRestaurant = Restaurant(
            name: restaurantName,
            address: restaurantAddress.isEmpty ? "City Center" : restaurantAddress,
            latitude: 10.7745,
            longitude: 106.7005
        )
        
        let newOrder = Order(
            restaurant: newRestaurant,
            customerName: customerName,
            deliveryAddress: deliveryAddress.isEmpty ? "Default Address" : deliveryAddress,
            latitude: lat,
            longitude: lng,
            status: "Pending"
        )
        
        orders.append(newOrder)
    }
}
