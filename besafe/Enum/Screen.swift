//
//  Screen.swift
//  besafe
//
//  Created by Paulus Michael on 20/08/24.
//

import Foundation

enum Screen: Identifiable, Hashable {
   case page1
   case page2
   case homeview
   case safeplaceview
   case nearbyplacesview
   case emergencycontactsview
   case direction
   
   var id: Self { return self }
}
