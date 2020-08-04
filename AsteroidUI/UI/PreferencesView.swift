//
//  PreferencesView.swift
//  AsteroidUI
//
//  Created by Xiaodong Ye on 2020/8/7.
//  Copyright © 2020 Xiaodong Ye. All rights reserved.
//

import SwiftUI

struct PreferencesView: View {
   @EnvironmentObject var appData: AppData

   var body: some View {
      HStack(alignment: .center) {
         GroupBox {
            List(0 ..< appData.prefs.count, selection: $appData.prefSelection) { i in
               VStack {
                  Spacer()
                  HStack {
                     Image(self.appData.prefs[i].image())
                     Text(self.appData.prefs[i].title())
                        .font(Font.headline)
                  }
                  .tag(i)
                  Spacer()
               }
            }
         }
         .frame(width: 200)
         .padding([.top, .leading, .bottom])
         Spacer()
         GroupBox {
            VStack(alignment: .leading) {
               VStack(alignment: .leading) {
                  Text(appData.prefs[appData.prefSelection ?? 0].title())
                     .font(Font.headline)
                     .padding([.top, .bottom], 5)
                  Text(appData.prefs[appData.prefSelection ?? 0].description())
                     .font(Font.subheadline)
                     .foregroundColor(Color(.secondaryLabelColor))
                     .padding(.bottom, 5)
               }
               Divider()
                  .padding(.bottom, 20)
               if (appData.prefSelection ?? 0) == Prefs.k8s.rawValue {
                  K8sPrefView(pref: appData.prefs[appData.prefSelection ?? 0] as! K8sPref, status: appData.status)
               } else if (appData.prefSelection ?? 0) == Prefs.container.rawValue {
                  ContainerPrefView(pref: appData.prefs[appData.prefSelection ?? 0] as! ContainerPref, status: appData.status)
               } else {
                  GeneralPrefView(pref: appData.prefs[appData.prefSelection ?? 0] as! GeneralPref)
               }
               Spacer()
            }
            .padding()
         }
         .padding([.top, .bottom, .trailing])
      }
   }
}

struct PreferencesView_Previews: PreviewProvider {
   static var previews: some View {
      PreferencesView()
   }
}
