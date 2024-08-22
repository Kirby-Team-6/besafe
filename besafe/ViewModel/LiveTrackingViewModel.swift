//
//  LiveTrackingViewModel.swift
//  besafe
//
//  Created by Romi Fadhurohman Nabil on 22/08/24.
//

import Foundation
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Connect to Socket.io server
        SocketHandler.shared.connect()

        // Start updating location
        SocketSendLocationViewModel.shared.startUpdatingLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Stop location updates when the view disappears
        SocketSendLocationViewModel.shared.stopUpdatingLocation()

        // Disconnect from Socket.io server
        SocketHandler.shared.disconnect()
    }
}
