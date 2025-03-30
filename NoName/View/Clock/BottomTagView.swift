//
//  BottomTagView.swift
//  NoName
//
//  Created by Nicoló Metani on 30/03/25.
//

import SwiftUI

struct BottomTagView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State private var tags = Tag()
    @State private var name: String = ""
    @State private var color: String = ""
    
    
    var body: some View {
        VStack{
            Form{
                TextField("Name", text: $name)
                TextField("Color", text: $color)
                TextField("Emoji", text: $tags.emoji)
            }
        }
    }
}

#Preview {
    BottomTagView()
}
