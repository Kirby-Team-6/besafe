//
//  DirectionView.swift
//  besafe
//
//  Created by Rifat Khadafy on 14/08/24.
//

import SwiftUI
import MapKit

struct DirectionView: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var viewmodel: DirectionViewmodel
    @StateObject private var locationManager = LocationManager()
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var selection = 0
    @State private var tabViewCount = 0
    @State private var completeRoute = false
    
    var body: some View {
        ZStack {
            Map(position: $position){
                UserAnnotation()
                if viewmodel.route != nil {
                    let strokeStyle = StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                    MapPolyline(viewmodel.route!)
                        .stroke(Color.blue, style: strokeStyle)
                }
            }
            VStack{
                if (viewmodel.route != nil){
                    HeaderDirectionView(selection: $selection, tabViewCount: $tabViewCount)
                }
                
                Spacer()
                HStack {
                    Button {
                        position = .userLocation(fallback: .automatic)
                    } label: {
                        Image(systemName: "location.fill.viewfinder")
                            .font(.title.weight(.semibold))
                            .padding()
                            .background(.background35)
                            .foregroundColor(.blue)
                            .clipShape(Circle())

                            .shadow(radius: 4, x: 0, y: 4)
                        
                    }
                    Spacer()
                }
                .padding()
                
                if (viewmodel.route != nil) {
                    FooterDirectionView()
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .top)
        .fullScreenCover(isPresented: $completeRoute){
            VStack {
                Text("You have arrived at\nthe safe place")
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .padding(.bottom, 24)
                    
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Reroute")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(maxWidth: UIScreen.main.bounds.width / 1.5)
                })
                .tint(.greyC6)
                .buttonBorderShape(.capsule)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.bottom, 10)
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Done")
                        .fontWeight(.semibold)
                        .frame(maxWidth: UIScreen.main.bounds.width / 1.5)
                })
                .tint(.blue)
                .buttonBorderShape(.capsule)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding(.horizontal, 10)
            .toolbar(.hidden, for: .navigationBar)
        }
        .onReceive(locationManager.$location){ location in
            if location == nil {
                return
            }
            if let route = viewmodel.route  {
                guard let lastStep2d = route.steps.last?.polyline.coordinate else {
                    return
                }
                let lastStep = CLLocation(latitude: lastStep2d.latitude, longitude: lastStep2d.longitude)
                let distance = lastStep.distance(from: location!)
                if distance <= 10 {
                    self.completeRoute = true
                }
            }
        }
        .onChange(of: selection){  old, newValue in
            let data = viewmodel.route!.steps[newValue]
            position = .camera(.init(centerCoordinate: data.polyline.coordinate, distance: 700))
        }
        .onReceive(viewmodel.$route) { v in
            if (v != nil){
                tabViewCount = v!.steps.count
            }
        }
        .onChange(of: position){ old, new in
            if new.region != nil {
                viewmodel.updateRegion(with: new.region!)
            }
        }
        .onAppear{
            CLLocationManager().requestWhenInUseAuthorization()
            CLLocationManager().startUpdatingLocation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if let cordinate = CLLocationManager().location?.coordinate {
                    viewmodel.getDirections(from: cordinate,  to: CLLocationCoordinate2D(latitude: 37.775511594494446,longitude:  -122.41872632127603))
                }
                
            }
            
        }
    }
}

#Preview {
    DirectionView()
}
