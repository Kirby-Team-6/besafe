//
//  Page1ViewController.swift
//  Kirbygoestohome
//
//  Created by Rifat Khadafy on 07/08/24.
//

import Foundation
import UIKit
import SwiftUI
import Combine

struct Page1: UIViewControllerRepresentable {
    
    @EnvironmentObject var router: Router
    
    
    func makeUIViewController(context: Context) -> Page1ViewController {
        let storyboard = UIStoryboard(name: "Page1", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "Page1") as! Page1ViewController
        controller.router = router
        controller.viewmodel = DI.shared.page1Viewmodel()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: Page1ViewController, context: Context){
        
    }
    
    
}

class Page1ViewController: UIViewController {
    var viewmodel: Page1Viewmodel?
    var router: Router?
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        viewmodel?.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                print(state)
            }
            .store(in: &cancellables)
        
        viewmodel?.loadData()
        
    }
    
    
    @IBAction func buttonClick(_ sender: Any) {
        router?.pushReplace(Screen.direction)
    }
    
}
