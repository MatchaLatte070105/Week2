import SwiftUI

struct ContentView: View {
    @State private var orders: [Order] = [
        Order(
            restaurant: Restaurant(name: "Pho 24", address: "10 Nguyen Van Linh, District 7", latitude: 10.7325, longitude: 106.7112),
            customerName: "Alex Smith",
            deliveryAddress: "123 Le Van Sy, District 3",
            latitude: 10.7850,
            longitude: 106.6780,
            status: "Pending"
        ),
        Order(
            restaurant: Restaurant(name: "Highlands Coffee", address: "72 Le Loi, District 1", latitude: 10.7745, longitude: 106.7005),
            customerName: "Emma Watson",
            deliveryAddress: "456 Dien Bien Phu, District 10",
            latitude: 10.7712,
            longitude: 106.6690,
            status: "In Transit"
        ),
        Order(
            restaurant: Restaurant(name: "Lotteria", address: "285 Cach Mang Thang 8, District 10", latitude: 10.7780, longitude: 106.6790),
            customerName: "Michael Jordan",
            deliveryAddress: "789 Au Co, District 11",
            latitude: 10.7650,
            longitude: 106.6490,
            status: "Pending"
        )
    ]
    
    @State private var showingAddOrderSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geometry in
                    Image("galaxy_bg")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
                .ignoresSafeArea()
                
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                
                VStack {
                    List {
                        ForEach(orders) { order in
                            NavigationLink(destination: OrderDetailView(order: order)) {
                                HStack(alignment: .center, spacing: 12) {
                                    Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                                        .font(.title2)
                                        .foregroundColor(.orange)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(order.restaurant.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text(order.restaurant.address)
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.7))
                                        
                                        Spacer().frame(height: 2)
                                        
                                        Text("Deliver to: \(order.customerName)")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                        Text(order.deliveryAddress)
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    
                                    Spacer()
                                    
                                    Text(order.status)
                                        .font(.caption2)
                                        .bold()
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(statusColor(order.status).opacity(0.25))
                                        .foregroundColor(statusColor(order.status))
                                        .cornerRadius(8)
                                }
                                .padding(.vertical, 6)
                            }
                            .listRowBackground(Color.white.opacity(0.12))
                        }
                        .onDelete(perform: deleteOrder)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    
                    Text("Total Orders: \(orders.count)")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.bottom, 8)
                }
            }
            .navigationTitle("Pending Deliveries")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddOrderSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
            }
            .sheet(isPresented: $showingAddOrderSheet) {
                AddOrderView(orders: $orders)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func deleteOrder(at offsets: IndexSet) {
        orders.remove(atOffsets: offsets)
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status {
        case "In Transit": return .orange
        case "Delivered": return .green
        default: return .cyan
        }
    }
}
