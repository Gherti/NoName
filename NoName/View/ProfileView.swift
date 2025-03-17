//
//  ProfileView.swift
//  NoName
//
//  Created by Nicoló Metani on 10/03/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            ZStack {
                Color(.sRGB, red: 142/255, green: 202/255, blue: 230/255).ignoresSafeArea(.all)
                VStack{
                    HStack{
                        Text("Calendar").padding().font(.system(size: 30, weight: .bold, design: .default))
                        Spacer()
                    }
                    Spacer()
                }.shadow(radius: 3)
            }
        }
    }
}

#Preview {
    ProfileView()
}
