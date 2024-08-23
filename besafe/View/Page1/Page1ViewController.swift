//
//  Page1ViewController.swift
//  Kirbygoestohome
//
//  Created by Rifat Khadafy on 07/08/24.
//

import Foundation
import UIKit
import SwiftUI

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
   @IBOutlet weak var labelPlaceholder: UILabel!
   
   
   override func viewDidLoad() {
      labelPlaceholder.layer.opacity = 0
   }
   
   @IBAction func dismissButton(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
   }
}
