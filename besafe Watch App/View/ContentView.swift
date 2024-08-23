//
//  ContentView.swift
//  besafe Watch App
//
//  Created by Rifat Khadafy on 14/08/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    @EnvironmentObject var router: Router
    @StateObject private var locationManager = LocationManager()
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var showCompleteView = false
    @State private var showControlDirection = true
    private let strokeStyle = StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
    @State private var currentStepIndex: Int = 1
    @State private var distancePerStep = 0
    @StateObject var watchConnect = WatchConnect.shared
    
    var body: some View {
        ZStack{
            Map(position: $position){
                UserAnnotation()
                MapPolyline(coordinates: watchConnect.routeModel!.polyLine.map{
                    CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
                })
                .stroke(Color.blue, style: strokeStyle)
                Marker("Direction", coordinate: CLLocationCoordinate2D(latitude:  watchConnect.routeModel!.polyLine.last!.latitude, longitude:  watchConnect.routeModel!.polyLine.last!.longitude))
            }.onTapGesture {
                withAnimation {
                    showControlDirection.toggle()
                }
            }
            VStack {
                Group{
                    let currentStep = watchConnect.routeModel!.steps[self.currentStepIndex]
                    let image = Direction.fromInstruction(currentStep.instruction).toImageName()
                    HStack {
                        Group{
                            if image == nil {
                                Image(systemName: "circle.dotted")
                                    .resizable()
                                    .foregroundColor(.blue)
                                    .scaledToFit()
                            } else {
                                Image(image!)
                                    .resizable()
                                    .foregroundColor(.white)
                                    .scaledToFit()
                            }
                        }
                        .frame(width: 30, height: 30)
                        .padding(9)
                        .background(.blue)
                        .clipShape(.circle)
                        .offset(x: -4)
                        
                        VStack(alignment: .leading){
                            Text("\(distancePerStep) m")
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                            Text(currentStep.instruction)
                                .font(.system(size: 12))
                                .lineLimit(2)
                                .fontWeight(.medium)
                                .opacity(0.6)
                        }
                        .padding(.vertical, 5)
                        .offset(x: -4)
                        
                        Spacer()
                    }
                    .frame(alignment: .leading)
                    .background(.black.opacity(0.5))
                    .cornerRadius(40)
                    
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        Text("\(getTime()?.time.description ?? "")")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("\(getTime()?.type ?? TimeFormatedType.days)")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment: .center) {
                        Text("\(Int(getDistance() ?? 0.0))")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("m")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    Button(action: {
                        CLLocationManager().stopUpdatingLocation()
                        router.pop()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                            watchConnect.routeModel = nil
                        }
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 40))
                            .foregroundStyle(.red, .white)
                    })
                    .buttonStyle(PlainButtonStyle())
                    
                }
                .frame(alignment: .leading)
                .background(.black.opacity(0.5))
                .cornerRadius(40)
                .padding(.bottom, 10)
                .transition(.move(edge: .bottom))
                .opacity(showControlDirection ? 1 : 0)
                
            }
            .ignoresSafeArea(.container)
            .padding(.horizontal, 10)
            .padding(.top, 0.5)
        }
        .fullScreenCover(isPresented: $showCompleteView){
            CompleteView(onRerouteTap: {
                
            }, onDoneTap: {
                router.pop()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    watchConnect.routeModel = nil
                }
            })
        }
        .onReceive(locationManager.$location) { location in
            if let location = location?.coordinate {
                getInstruction(for: CLLocation(latitude: location.latitude, longitude: location.longitude))
                if let route = watchConnect.routeModel  {
                    guard let lastStep2d = route.steps.last else {
                        return
                    }
                    let lastStep = CLLocation(latitude: lastStep2d.latitude, longitude: lastStep2d.longitude)
                    let distance = lastStep.distance(from: CLLocation(latitude: location.latitude, longitude: location.longitude))
                    print(distance)
                    if distance <= 10 {
                        CLLocationManager().stopUpdatingLocation()
                        showCompleteView = true
                    }
                }
                
            }
        }
        .onAppear{
            CLLocationManager().requestWhenInUseAuthorization()
            CLLocationManager().startUpdatingLocation()
        }
    }
    
    private func getTime() -> TimeFormated? {
        return watchConnect.routeModel!.time.rounded().secTimeFormatted()
    }
    
    private func getDistance() -> Double? {
        return watchConnect.routeModel!.distance.rounded()
    }
    
    func getInstruction(for location: CLLocation) {
        // Define a threshold distance to determine if you are close enough to proceed to the next location
        let thresholdDistance: CLLocationDistance = 15.0 // meters
        
        // Get the current step location
        let currentStep = watchConnect.routeModel!.steps[currentStepIndex]
        let currentStepLocation = CLLocation(latitude: currentStep.latitude, longitude: currentStep.longitude)
        
        // Calculate the distance from the current location to the current step location
        let distanceToCurrentStep = location.distance(from: currentStepLocation)
        
        // Check if we should proceed to the next location
        if distanceToCurrentStep < thresholdDistance {
            if currentStepIndex < watchConnect.routeModel!.steps.count - 1 {
                currentStepIndex += 1
            }
        }
        
        // Get the closest step after updating the current step index if necessary
        let closestStep = watchConnect.routeModel!.steps[currentStepIndex]
        
        // Calculate the distance to the next step
        self.distancePerStep = Int(CLLocation(latitude: closestStep.latitude, longitude: closestStep.longitude).distance(from: location).rounded())
    }
}

