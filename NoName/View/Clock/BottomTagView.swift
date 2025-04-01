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
    @State private var color: Color = .white
    
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
                    tag.color = color.toHex()
                    if !taskModel.checkTag(tagToCheck: tag) {
                        taskModel.addTag(tag: tag, context: modelContext)
                        dismiss()
                    }
                    else{
                        print("Tag già esistente")
                    }
                    //Controllo tag
                    
                    
                }){
                    Text("Add")
                        .padding([.leading, .bottom, .trailing])
                        .font(.system(size: 22, weight: .semibold))
                }
                .disabled(name.isEmpty || color.isWhiteOrNearWhite())
            }
            Form{
                TextField("Name", text: $name)
                
                TextField("Emoji", text: $tag.emoji)
                ColorPicker("Scegli un colore", selection: $color)
                
            }
        }
    }
}

extension Color {
    // Converti Color in HEX String usando getRed
    func toHex() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        let uiColor = UIColor(self)
        if uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let r = Int(red * 255)
            let g = Int(green * 255)
            let b = Int(blue * 255)
            return String(format: "#%02X%02X%02X", r, g, b)
        }
        return "#FFFFFF"  // fallback se getRed fallisce
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
    
    // Verifica se il colore è bianco o molto vicino al bianco
    func isWhiteOrNearWhite() -> Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        let uiColor = UIColor(self)
        
        if uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            // Consideriamo il colore come bianco se tutti i componenti RGB sono vicini a 1.0
            return (red > 0.95 && green > 0.95 && blue > 0.95)
        }
        
        return true  // fallback, assume bianco se la conversione fallisce
    }
}


#Preview {
    BottomTagView()
        .environmentObject(DateModel())
        .environmentObject(TimeModel())
        .environmentObject(TaskModel())
}
