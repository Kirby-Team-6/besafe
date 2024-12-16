//
//  CustomLabelController.swift
//  besafe
//
//  Created by Paulus Michael on 22/08/24.
//

import Foundation
import UIKit

@IBDesignable class CustomLabelController: UILabel {
   @IBInspectable var topPadding: CGFloat = 0.0
   @IBInspectable var leadingPadding: CGFloat = 0.0
   @IBInspectable var bottomPadding: CGFloat = 0.0
   @IBInspectable var trailingPadding: CGFloat = 0.0
   
   convenience init(padding: UIEdgeInsets) {
      self.init()
      self.topPadding = padding.top
      self.leadingPadding = padding.left
      self.bottomPadding = padding.bottom
      self.trailingPadding = padding.right
   }
   
   override func drawText(in rect: CGRect) {
      let padding = UIEdgeInsets.init(top: topPadding, left: leadingPadding, bottom: bottomPadding, right: trailingPadding)
      super.drawText(in: rect.inset(by: padding))
   }
   
   override var intrinsicContentSize: CGSize {
      var contentSize = super.intrinsicContentSize
      contentSize.width = self.leadingPadding + self.trailingPadding
      contentSize.height = self.topPadding + self.bottomPadding
      return contentSize
   }
}
