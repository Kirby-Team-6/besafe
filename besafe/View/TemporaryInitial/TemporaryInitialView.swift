//
//  TemporaryInitialView.swift
//  besafe
//
//  Created by Rifat Khadafy on 20/08/24.
//

import SwiftUI
import CoreLocation

struct TemporaryInitialView: View {
    @EnvironmentObject var router: Router
    @StateObject var viewmodel = DI.shared.temporaryInitialViewmodel()
    
    var body : some View {
        VStack {
            Button(action: {
                router.push(Screen.homeview)
            }, label: {
                Text("Home")
            })
            Button(action: {
                CLLocationManager().requestWhenInUseAuthorization()
                if let cordinate = CLLocationManager().location?.coordinate {
                    viewmodel.getNearbyPlace(latitude: cordinate.latitude, longitude: cordinate.longitude)
                }
//                viewmodel.getNearbyPlace(latitude: , longitude: )
            }, label: {
                Text("Direction")
            })
        }
    }
}
