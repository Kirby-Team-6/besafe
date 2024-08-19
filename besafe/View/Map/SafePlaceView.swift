import SwiftUI

struct SafePlaceView: View {
    @StateObject private var viewModel = SafePlacesViewModel()
    
    var body: some View {
        List(viewModel.safePlaces, id: \.name) { place in
            let distance = viewModel.distanceToPlace(place)
            Text("\(place.name) - \(place.types.first ?? "Unknown") = \(String(format: "%.2f", distance)) meters")
        }
        .onAppear {
            viewModel.loadSafePlaces()
           
        }
    }

}


#Preview {
    SafePlaceView()
}
