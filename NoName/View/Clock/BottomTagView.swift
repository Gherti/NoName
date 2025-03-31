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
    @EnvironmentObject var taskModel: TaskModel
    
    
    @State private var tag = Tag()
    @State private var name: String = ""
    @State private var color: String = ""
    
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    dismiss()
                }){
                    Text("Cancel")
                        .padding([.leading, .bottom, .trailing])
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.red)
                }
                
                Spacer()
                
                Button(action: {
                    
                    tag.name = name
                    //Controllo tag
                    taskModel.addTag(tag: tag, context: modelContext)
                    dismiss()
                }){
                    Text("Add")
                        .padding([.leading, .bottom, .trailing])
                        .font(.system(size: 22, weight: .semibold))
                }
                .disabled(name.isEmpty || tag.color.isEmpty)
            }
            Form{
                TextField("Name", text: $name)
                
                TextField("Emoji", text: $tag.emoji)
                ColorPicker("Scegli un colore", selection: Binding(
                    get: { Color(hex: tag.color) },
                    set: { tag.color = $0.toHex() }
                ))
            }
            
        }
    }
}

extension Color {
    // Converti Color in HEX String
    func toHex() -> String {
        guard let components = UIColor(self).cgColor.components else { return "#FFFFFF" }
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    // Crea un Color da HEX String
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    BottomTagView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel())
}
