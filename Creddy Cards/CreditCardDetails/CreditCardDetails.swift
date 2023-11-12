//

import SwiftUI

struct CreditCardDetails: View {
    
    @ScaledMetric private var scaling = 35
    
    var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: scaling) {
            Text(viewModel.creditCard.type.displayText)
                    .font(.headline)

            Text(viewModel.creditCard.cardNumber)
                .font(.title)
                .bold()
              
            HStack {
                VStack(alignment: .leading) {
                    Text("Card Holder Name")
                        .font(.caption)
                    Text(randomName)
                        .font(.body)
                }
                
                VStack(alignment: .leading) {
                    Text("Expiry Date")
                        .font(.caption)
                    Text(viewModel.creditCard.expiry, format: .dateTime.month().year())
                        .font(.body)
                }
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.3))
                    .frame(width: scaling * 2, height: scaling * 1.1)
            }
        }
        .padding()
        .background {
            LinearGradient(colors: randomColors, startPoint: randomPoint(seededBy: viewModel.creditCard.id), endPoint: randomPoint(seededBy: viewModel.creditCard.cardNumber.hashValue))
        }
        .clipShape(RoundedRectangle(cornerRadius: scaling / 5), style: FillStyle())
        .shadow(radius: scaling / 2)
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.toggleFavourite()
                } label: {
                    Label("Toggle Favourite", 
                          systemImage: viewModel.creditCard.isFavourite ? "heart.fill" : "heart"
                    )
                        .labelStyle(IconOnlyLabelStyle())
                }
                .contentTransition(.symbolEffect(.replace))
            }
        }
        .navigationTitle("Details")
    }
    
    
    private func randomPoint(seededBy seed: Int) -> UnitPoint {
        var randomGenerator = SeededRandomNumberGenerator(seed: seed)
        let points: [UnitPoint] = [.bottom, .bottomLeading, .bottomTrailing, .center, .leading, .topLeading, .topTrailing, .top, .trailing]
        return points.randomElement(using: &randomGenerator)!
    }
    
    private var randomColors: [Color] {
        var randomGenerator = SeededRandomNumberGenerator(seed: viewModel.creditCard.id)
        let someColors: [Color] = [.red, .green, .blue, .orange, .cyan, .indigo, .mint, .pink]
        return Array(someColors.shuffled(using: &randomGenerator).prefix(3))
    }
    
    private var randomName: String {
        var randomGenerator = SeededRandomNumberGenerator(seed: viewModel.creditCard.id)
        let someGivenNames = ["John", "Joe", "Joanna", "Sarah"]
        let someFamilyNames = ["Douglas", "Brown", "Becker", "Wong"]
        return someGivenNames.randomElement(using: &randomGenerator)! + " " + someFamilyNames.randomElement(using: &randomGenerator)!
    }
}

struct SeededRandomNumberGenerator: RandomNumberGenerator {

    private let range: ClosedRange<Double> = Double(UInt64.min) ... Double(UInt64.max)

    init(seed: Int) {
        // srand48() — Pseudo-random number initializer
        srand48(seed)
    }
    
    mutating func next() -> UInt64 {
        // drand48() — Pseudo-random number generator
        UInt64(range.lowerBound + (range.upperBound - range.lowerBound) * drand48())
    }
}

#Preview {
    CreditCardDetails(viewModel: .init(creditCard: .init(id: 1, uid: UUID(uuidString: "1a9dd0dc-f513-4447-9000-cf4605d774e7")!, cardNumber: "1234-1234-1234-1234", expiry: Date.now, type: .americanExpress, isFavourite: false), repository: StubbedCreditCardRepository()))
}
