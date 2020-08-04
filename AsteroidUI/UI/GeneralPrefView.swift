//
//  GeneralPrefView.swift
//  AsteroidUI
//
//  Created by Xiaodong Ye on 2020/8/22.
//  Copyright © 2020 Xiaodong Ye. All rights reserved.
//

import SwiftUI

struct GeneralPrefView: View {
   @ObservedObject var pref: GeneralPref
   var body: some View {
      VStack(alignment: .leading) {
         Toggle(isOn: $pref.launchAtLogin) {
            Text(String(format: Strings.LaunchAtLogin, Strings.ProductName))
         }
         .padding(.bottom)
         Toggle(isOn: $pref.automaticallyChecksForUpdates) {
            Text(Strings.AutomaticallyChecksForUpdates)
         }
         .padding(.bottom)
         Toggle(isOn: $pref.compactStorage) {
            Text(Strings.AutomaticallyCompactStorage)
         }
      }
   }
}

struct GeneralPrefView_Previews: PreviewProvider {
   static var previews: some View {
      GeneralPrefView(pref: GeneralPref())
   }
}
