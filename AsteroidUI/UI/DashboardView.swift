//
//  DashboardView.swift
//  AsteroidUI
//
//  Created by Xiaodong Ye on 2020/8/7.
//  Copyright © 2020 Xiaodong Ye. All rights reserved.
//

import SwiftUI

struct UsageView: View {
   @ObservedObject var usage: Usage

   func getProgressBarWidth(geometry: GeometryProxy) -> CGFloat {
      let frame = geometry.frame(in: .global)
      return frame.size.width * usage.percentage
   }

   func getPercentageText(_ value: CGFloat) -> String {
      let intValue = Int(ceil(value * 100))
      return "\(intValue)%"
   }

   var body: some View {
      GroupBox {
         VStack {
            HStack {
               Text(usage.text)
                  .font(Font.footnote.smallCaps())
               Spacer()
               Text(String(format: Strings.Used, self.getPercentageText(usage.percentage)))
                  .font(Font.footnote.smallCaps())
            }
            GeometryReader { geometry in
               ZStack(alignment: .leading) {
                  Rectangle()
                     .foregroundColor(Color(.controlColor))
                     .cornerRadius(4)
                  Rectangle()
                     .foregroundColor(Color(.linkColor))
                     .cornerRadius(4)
                     .frame(minWidth: 0,
                            idealWidth: self.getProgressBarWidth(geometry: geometry),
                            maxWidth: self.getProgressBarWidth(geometry: geometry))
               }
               .frame(height: 8)
            }
         }
         .padding()
      }
   }
}

struct DashboardView: View {
   @EnvironmentObject var appData: AppData
   var body: some View {
      VStack {
         ForEach(appData.usages) { usage in
            UsageView(usage: usage)
               .padding([.leading, .trailing], 10)
               .padding([.top, .bottom], 5)
         }
      }
   }
}

struct DashboardView_Previews: PreviewProvider {
   static var previews: some View {
      DashboardView()
   }
}
