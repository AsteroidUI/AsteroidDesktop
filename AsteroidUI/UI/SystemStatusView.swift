//
//  SystemStatusView.swift
//  AsteroidUI
//
//  Created by Xiaodong Ye on 2020/8/6.
//  Copyright © 2020 Xiaodong Ye. All rights reserved.
//

import SwiftUI

struct SystemStatusView: View {
   @EnvironmentObject var status: Status

   var body: some View {
      HStack(alignment: .center) {
         Circle()
            .fill(status.color)
            .frame(width: 12, height: 12)
         Text("\(Strings.ProductName) \(status.text)")
            .foregroundColor(Color(.disabledControlTextColor))
            .font(Font(NSFont.menuFont(ofSize: NSFont.systemFontSize)))
      }.padding()
   }
}

struct SystemStatusView_Previews: PreviewProvider {
   static var previews: some View {
      SystemStatusView()
   }
}
