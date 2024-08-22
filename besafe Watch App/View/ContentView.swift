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
    @State private var currentStepIndex: Int = 0
    @State private var distancePerStep = 0
    private let routeModel = RouteModel(
        distance: 300,
        time: 4 * 60,
        steps: [
            StepsRoute(
                instruction: "Start on turk st",
                latitude: 37.78325029249207,
                longitude: -122.41067913583242
            ),
            StepsRoute(
                instruction: "Cross the street and turn left onto Mason St",
                latitude: 37.78350464898974,
                longitude: -122.40925155727867
            ),
            StepsRoute(
                instruction: "The destination is on your right",
                latitude: 37.78481637233787,
                longitude:  -122.40936690608494
            ),
        ],
        polyLine: [
            RoutePolyline(37.78325029249207, -122.41067913583242),
            RoutePolyline(37.783386442366755, -122.40923763606513),
            RoutePolyline(37.78351225698025, -122.40925698538052),
            RoutePolyline(37.78353728085573, -122.40908548008484),
            RoutePolyline(37.78426916536508, -122.40924224237935),
            RoutePolyline(37.78480238941566, -122.40936962227111),
        ]
    )
    
   var body: some View {
       ZStack{
           Map(position: $position){
              UserAnnotation()
               MapPolyline(coordinates: routeModel.polyLine.map{
                   CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
               })
                   .stroke(Color.blue, style: strokeStyle)

           }.onTapGesture {
               withAnimation {
                   showControlDirection.toggle()
               }
           }
           VStack {
               Group{
                   let currentStep = routeModel.steps[self.currentStepIndex]
                   let image = Direction.fromInstruction(currentStep.instruction).toImageName()
                   HStack {
                       if image != nil {
                           Image(image!)
                            .font(.system(size: 28))
                           .padding(9)
                           .background(.blue)
                           .clipShape(.circle)
                           .offset(x: -4)
                       }
                       
                       VStack(alignment: .leading){
                           Text("\(distancePerStep) m")
                               .font(.system(size: 18))
                               .fontWeight(.semibold)
                           Text(currentStep.instruction)
                               .font(.system(size: 12))
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
           CompleteView()
       }
       .onReceive(locationManager.$location) { location in
           if let location = location?.coordinate {
               position = .camera(.init(centerCoordinate:location, distance: 500))
               getInstruction(for: CLLocation(latitude: location.latitude, longitude: location.longitude))
           }
       }
       .onAppear{
         CLLocationManager().requestWhenInUseAuthorization()
           CLLocationManager().startUpdatingLocation()
      }
   }
    
    private func getTime() -> TimeFormated? {
        return routeModel.time.rounded().secTimeFormatted()
    }
    
    private func getDistance() -> Double? {
        return routeModel.distance.rounded()
    }
    
    func getInstruction(for location: CLLocation)  {
        let currentStep = routeModel.steps[currentStepIndex]
        let currentStepLocation = CLLocation(latitude: currentStep.latitude, longitude: currentStep.longitude)
        
        if location.distance(from: currentStepLocation) < 10 {
            if currentStepIndex < routeModel.steps.count - 1 {
                currentStepIndex += 1
            }
        }
        
        let closestStep = routeModel.steps[currentStepIndex]
        
        self.distancePerStep = Int(CLLocation(latitude: closestStep.latitude, longitude: closestStep.longitude).distance(from: location).rounded())

    }
}

