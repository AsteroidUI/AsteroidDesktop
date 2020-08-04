//
//  AboutView.swift
//  AsteroidUI
//
//  Created by Xiaodong Ye on 2020/8/7.
//  Copyright © 2020 Xiaodong Ye. All rights reserved.
//

import SwiftUI

struct AboutView: View {
   @EnvironmentObject var appData: AppData
   var body: some View {
      HStack(alignment: .center) {
         Image("sidebar")
         VStack {
            HStack {
               VStack(alignment: .leading) {
                  Text(Strings.ProductName)
                     .font(Font.headline)
                     .padding([.top, .bottom], 5)
                  Text(appData.versions.app)
                     .font(Font.subheadline)
                     .padding(.bottom, 5)
               }
               Spacer()
               Text("\(Strings.GitHub)")
                  .underline()
                  .onTapGesture {
                     Opener.openGitHub(sender: nil)
                  }
                  .foregroundColor(Color(.linkColor))
            }
            Divider()
               .padding(.bottom, 5)

            HStack {
               VStack(alignment: .leading) {
                  HStack {
                     Image("vctl").frame(width: 30)
                     Text("vctl: \(appData.versions.vctl)")
                  }
                  HStack {
                     Image("kind")
                     Text("kind: \(appData.versions.kind)")
                  }
               }
               Spacer(minLength: 50)
               VStack(alignment: .leading) {
                  HStack {
                     Image("containerd")
                     Text("containerd: \(appData.versions.containerd)")
                  }
                  HStack {
                     Image("kubectl")
                     Text("kubectl client: \(appData.versions.kubectl)")
                  }
               }
               Spacer()
            }
            Spacer()
            HStack {
               Text("\(Strings.ReleaseNotes)")
                  .underline()
                  .onTapGesture {
                     Opener.openReleaseNotes(sender: nil)
                  }
                  .foregroundColor(Color(.linkColor))
               Spacer()
               Text("\(Strings.Copyright)")
            }
         }.padding()
      }
   }
}

struct AboutView_Previews: PreviewProvider {
   static var previews: some View {
      AboutView().frame(width: 500.0, height: 500.0)
   }
}
