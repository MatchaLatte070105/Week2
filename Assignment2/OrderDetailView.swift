import SwiftUI
import MapKit

struct OrderDetailView: View {
    @State var order: Order
    @State private var distanceKm: Double = 0.0
    @State private var travelTimeMinutes: Double = 0.0
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("galaxy_bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
            .ignoresSafeArea()
            
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Map {
                    Annotation(order.restaurant.name, coordinate: CLLocationCoordinate2D(latitude: order.restaurant.latitude, longitude: order.restaurant.longitude)) {
                        Image(systemName: "fork.knife.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                            .background(Circle().fill(.white))
                    }
                    
                    Annotation("Deliver to", coordinate: CLLocationCoordinate2D(latitude: order.latitude, longitude: order.longitude)) {
                        Image(systemName: "house.circle.fill")
                            .font(.title)
                            .foregroundColor(.cyan)
                            .background(Circle().fill(.white))
                    }
                }
                .frame(height: 250)
                .cornerRadius(16)
                .padding(.horizontal)
                .padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Spacer()
                        VStack(spacing: 4) {
                            Text(String(format: "%.1f km", distanceKm))
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                            Text(String(format: "~ %.0f mins", travelTimeMinutes))
                                .font(.subheadline)
                                .foregroundColor(.cyan)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 24)
                        .background(Color.white.opacity(0.12))
                        .cornerRadius(12)
                        Spacer()
                    }
                    
                    Divider().background(Color.white.opacity(0.3))
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: "storefront.fill")
                                .foregroundColor(.orange)
                            Text(order.restaurant.name)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        Text(order.restaurant.address)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Spacer().frame(height: 4)
                        
                        HStack(spacing: 8) {
                            Image(systemName: "person.fill")
                                .foregroundColor(.cyan)
                            Text("Customer: \(order.customerName)")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        Text("Address: \(order.deliveryAddress)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Button(action: toggleStatus) {
                        Text("Status: \(order.status)")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(statusColor(order.status))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.55))
                .cornerRadius(20)
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            calculateDistance()
        }
    }
    
    private func calculateDistance() {
        let sourceCoord = CLLocationCoordinate2D(latitude: order.restaurant.latitude, longitude: order.restaurant.longitude)
        let destCoord = CLLocationCoordinate2D(latitude: order.latitude, longitude: order.longitude)
        
        MapService.getRoute(from: sourceCoord, to: destCoord) { dist, time, _ in
            DispatchQueue.main.async {
                self.distanceKm = dist
                self.travelTimeMinutes = time
            }
        }
    }
    
    private func toggleStatus() {
        if order.status == "Pending" {
            order.status = "In Transit"
        } else if order.status == "In Transit" {
            order.status = "Delivered"
        } else {
            order.status = "Pending"
        }
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status {
        case "In Transit": return .orange
        case "Delivered": return .green
        default: return .blue
        }
    }
}
