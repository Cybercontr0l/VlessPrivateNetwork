import SwiftUI
import NetworkExtension


struct ContentView: View {
    @State private var isConnected = false

    var body: some View {
        VStack {
            Button(action: {
                if isConnected {
                    VPNManager.shared.stopVPN()
                } else {
                    VPNManager.shared.startVPN()
                }
                isConnected.toggle()
            }) {
                Text(isConnected ? "Disconnect" : "Connect")
                    .font(.title)
                    .padding()
                    .frame(width: 200)
                    .background(isConnected ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .onAppear {
            VPNManager.shared.loadProviderManager()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
