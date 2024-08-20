//
//  FooterDirectionView.swift
//  besafe
//
//  Created by Rifat Khadafy on 20/08/24.
//

import SwiftUI
import CoreLocation

struct FooterDirectionView: View {
    @EnvironmentObject private var viewmodel: MainViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            VStack(alignment: .center) {
                Text(getTime()?.time.description ?? "")
                    .font(.system(size: 36))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("\(getTime()?.time ?? 0)")
                    .font(.system(size: 24))
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .center) {
                Text("\(Int(getDistance() ?? 0.0))")
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
                withAnimation {
                    viewmodel.route = nil
                    CLLocationManager().stopUpdatingLocation()
                }
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
        .transition(.move(edge: .bottom))
        .animation(.default, value: viewmodel.route != nil)
    }
    
    private func getTime() -> TimeFormated? {
        return viewmodel.route?.expectedTravelTime.rounded().secTimeFormatted()
    }
    
    private func getDistance() -> Double? {
        return viewmodel.route?.distance.rounded()
    }
    
}
