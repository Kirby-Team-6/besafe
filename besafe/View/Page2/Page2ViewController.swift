//
//  Page1ViewController.swift
//  Kirbygoestohome
//
//  Created by Rifat Khadafy on 08/08/24.
//

import Foundation
import UIKit
import SwiftUI

struct Page2: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "Page2", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "Page2")
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context){
        
    }
}

class Page2ViewController: UIViewController {
    override func viewDidLoad() {
        
    }
}
