//
//  BotttomSheetView.swift
//  NoName
//
//  Created by Nicoló Metani on 17/03/25.
//

import SwiftUI

struct BotttomSheetView: View {
    @EnvironmentObject var viewModel: TimeViewModel
    @State private var inizio =  Date()
    @State private var fine =  Date()
    
    var body: some View {
        VStack{
            HStack{
                Text("Cancel").padding().font(.system(size: 25, weight: .bold, design: .default))
                Spacer()
                Button(action: {
                    viewModel.updateTimeStart(from: inizio)
                    viewModel.updateTimeFinish(from: fine)
                }){
                    Text("Add").padding().font(.system(size: 25, weight: .bold, design: .default))}
                
            }
            Spacer()
            GroupBox{
                DatePicker("Inizio", selection: $inizio, displayedComponents: .hourAndMinute).padding()
                
                DatePicker("Fine", selection: $fine, displayedComponents: .hourAndMinute).padding()
            }.padding()
            Spacer()
            Spacer()
        }
    }
    
    
}

#Preview {
    BotttomSheetView()
}
