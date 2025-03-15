import SwiftUI

struct ClockView: View {
    var body: some View {
            VStack{
                ZStack(){
                    Color(.sRGB, red: 142/255, green: 202/255, blue: 230/255).ignoresSafeArea(.all)
                    
                    VStack{
                        HStack{
                            Text("Clock").padding().font(.system(size: 30, weight: .bold, design: .default))
                            Spacer()
                            Image(systemName: "plus.circle").resizable().frame(width:
                                                                                40.0, height: 40.0).padding()
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "circle.lefthalf.filled.inverse").resizable().frame(width: 40.0, height: 40.0).padding().padding(.bottom, 60.0)
                            
                        }
                    }.shadow(radius: 5)
                    AnalogClockView()
                    
                }
            }
    }
}

#Preview {
    ClockView()
}
