import SwiftUI

struct TestView: View {
    @State private var tokenSupply = TokenSupply(playerCount: 2)
    @State private var primeCount = 4
    
    var body: some View {
        VStack(spacing: 40) {
            Text("Primedor Test")
                .font(.largeTitle)
            
            Text("Prime tokens: \(primeCount)")
                .font(.title)
            
            Button("Take 1 Prime Token") {
                if let tokens = tokenSupply.take(.prime, count: 1) {
                    primeCount = tokenSupply.count(of: .prime)
                    print("Took token! Remaining: \(primeCount)")
                }
            }
            .buttonStyle(.borderedProminent)
            .font(.title2)
        }
    }
}
