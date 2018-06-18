import UIKit
import TypedForms

struct Card: Equatable, CustomStringConvertible {

    let name: String
    let currencies: [String]

    var description: String {
        return name
    }
}

class ViewController: FormViewController<ViewController.ViewModel> {

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

    init() {

        let card1 = Card(name: "Card #1", currencies: ["CZK", "EUR"])
        let card2 = Card(name: "Card #2", currencies: ["EUR", "PLN", "GBP"])
        let card3 = Card(name: "Card #3", currencies: ["EUR"])
        let model = ViewModel(
            cards: [card1, card2, card3], selectedCard: card2,
            selectedCurrency: "EUR", specifyAmount: false, amount: "1000")

        let form = Form<ViewModel>()

        form += SelectableSection("Cards", items: \.cards, selectedItem: \.selectedCard)

        form += Section("Currency")
            <<< FormSegmentedCell(items: \.selectedCard.currencies, selectedItem: \.selectedCurrency)

        form += Section()
            <<< FormSwitchCell(keyPath: \.specifyAmount, title: "Specify Amount")
            <<< FormTextFieldCell(keyPath: \.amount) {
                $0.bind(\.isHidden, to: \.specifyAmount, through: { !$0 })
            }

        form += Section()
            <<< FormButtonCell(title: "Pay") {
                $0.bind(\.shouldHighlight, to: \.canBeSubmitted)
            }

        super.init(model: model, form: form)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
