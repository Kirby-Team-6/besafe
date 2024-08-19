import SwiftUI

struct SafePlaceView: View {
    @StateObject private var viewModel = SafePlacesViewModel()
    
    var body: some View {
        VStack {
            if let selectedPlace = viewModel.selectedSafePlace {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Selected Safe Place")
                        .font(.headline)
                    
                    Text("\(selectedPlace.name)")
                        .font(.title)
                    
                    Text("Type: \(selectedPlace.types.first ?? "Unknown")")
                    
                    let distance = viewModel.distanceToPlace(selectedPlace)
                    Text("Distance: \(String(format: "%.2f", distance)) meters")
                }
                .padding()
            }
            
            Button(action: {
                viewModel.reroute()
            }) {
                Text("Reroute")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            List(viewModel.safePlaces, id: \.name) { place in
                if !viewModel.shouldExcludePlace(place) {
                    let distance = viewModel.distanceToPlace(place)
                    Text("\(place.name) - \(place.types.first ?? "Unknown") = \(String(format: "%.2f", distance)) meters")
                }
            }
        }
        .onAppear {
            viewModel.loadSafePlaces()
        }
    }
}

#Preview {
    SafePlaceView()
}
