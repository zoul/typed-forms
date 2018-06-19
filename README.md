Tables are often used to build forms on iOS, but the `UITableView` API is fairly low-level, offering a plenty of rope to hang yourself. This library attempts to think of a better, high-level API for building type-safe(r) forms using tables.

The key idea is splitting the particular form logic into a standalone view model type that handles just the logic, and then using simple, declarative rules to build the table cells from that model:

```
//
// The view model
//

struct Card: Equatable, CustomStringConvertible {

    let name: String
    let currencies: [String]

    var description: String {
        return name
    }
}


struct ViewModel {

    var cards: [Card]
    var selectedCard: Card {
        didSet {
            selectedCurrency = selectedCard.currencies.first!
        }
    }

    var selectedCurrency: String
    var specifyAmount: Bool
    var amount: String

    var canBeSubmitted: Bool {
        return !specifyAmount || Double(amount) != nil
    }
}

//
// Sample data
//

let card1 = Card(name: "Card #1", currencies: ["CZK", "EUR"])
let card2 = Card(name: "Card #2", currencies: ["EUR", "PLN", "GBP"])
let card3 = Card(name: "Card #3", currencies: ["EUR"])
let model = ViewModel(
    cards: [card1, card2, card3], selectedCard: card2,
    selectedCurrency: "EUR", specifyAmount: false, amount: "1000")

//
// Now let’s build a form from that
//

let form = Form<ViewModel>()

form += SelectableSection("Cards", items: \.cards, selectedItem: \.selectedCard)

form += Section("Currency")
    <<< FormSegmentedCell(items: \.selectedCard.currencies, selectedItem: \.selectedCurrency)

form += Section()
    <<< FormSwitchCell(keyPath: \.specifyAmount, title: "Specify Amount")
    <<< FormTextFieldCell(keyPath: \.amount) {
        $0.textField.placeholder = "Enter amount"
        $0.textField.clearButtonMode = .whileEditing
        $0.bind(\.isHidden, to: \.specifyAmount, through: { !$0 })
    }

form += Section()
    <<< FormButtonCell(title: "Pay") {
        $0.bind(\.shouldHighlight, to: \.canBeSubmitted)
    }
}
```