//
//  DirectionView.swift
//  besafe
//
//  Created by Rifat Khadafy on 14/08/24.
//

import SwiftUI
import MapKit

struct DirectionView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewmodel: DirectionViewmodel
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var selection = 0
    @State private var tabViewCount = 0
    
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
            .onAppear{
                //                CLLocationManager().location?.coordinate
            }
            .onChange(of: position){ old, new in
                if new.region != nil {
                    viewmodel.updateRegion(with: new.region!)
                }
            }
            VStack{
                VStack{
                    TabView(selection : $selection){
                        ForEach(
                            Array((viewmodel.route?.steps ?? []).enumerated()), id: \.offset)
                        { index, element in
                            let distance = Int(element.distance.rounded())
                            HStack (alignment: .top){
                                if (distance > 0){
                                    Image(systemName: "arrow.turn.up.left")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white)
                                        .padding(.leading, 10)
                                        .padding(.trailing, 20)

                                }
                                                                
                                VStack(alignment: .leading) {
                                    if(distance > 0 ){
                                        Text("\(distance) m")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                   
                                    Text(element.instructions)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                                Spacer()

                            }
                            
                        }
                        
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                    .padding(.bottom, 0)
                    
                    PageControlView(currentPage: $selection, numberOfPages: $tabViewCount)
                }
                .padding()
                .background(.black)
                .frame(width: UIScreen.main.bounds.width, height: 150, alignment: .top)
                
                
                Spacer()
                
                if (viewmodel.route != nil) {
                    let time = viewmodel.route!.expectedTravelTime.rounded().secTimeFormatted()
                    let distance = viewmodel.route!.distance.rounded()
                    HStack(alignment: .center) {
                        Spacer()
                        VStack(alignment: .center) {
                            Text(time.time.description)
                                .font(.system(size: 36))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("\(time.type.self)")
                                .font(.system(size: 24))
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .center) {
                            Text("\(Int(distance))")
                                .font(.system(size: 36))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("m")
                                .font(.system(size: 24))
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 60)
                        
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .symbolRenderingMode(.multicolor)
                                .font(.system(size: 60))
                                .foregroundStyle(.red, .white)
                        })
                        Spacer()
                    }
                    .padding(.top, 12)
                    .background(.black)
                    .frame(width: UIScreen.main.bounds.width, alignment: .top)

                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .top)
        .onChange(of: selection){  old, newValue in
            let data = viewmodel.route!.steps[newValue]
            position = .camera(.init(centerCoordinate: data.polyline.coordinate, distance: 700))
        }
        .onReceive(viewmodel.$route) { v in
            if (v != nil){
                tabViewCount = v!.steps.count
            }
        }
        .onAppear{
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
