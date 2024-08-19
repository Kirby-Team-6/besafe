//
//  PageControlView.swift
//  besafe
//
//  Created by Rifat Khadafy on 15/08/24.
//

import Foundation
import UIKit
import SwiftUI

struct PageControlView: UIViewRepresentable {
    @Binding var currentPage: Int
    @Binding var numberOfPages: Int

    func makeUIView(context: Context) -> UIPageControl {
        let uiView = UIPageControl()
        uiView.backgroundStyle = .minimal
        uiView.currentPage = currentPage
        uiView.numberOfPages = numberOfPages
        return uiView
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
        uiView.numberOfPages = numberOfPages
    }
}
