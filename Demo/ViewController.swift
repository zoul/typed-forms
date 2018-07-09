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
        var amount: String?

        var canBeSubmitted: Bool {
            guard specifyAmount else { return true }
            guard let amount = amount else { return false }
            return Double(amount) != nil
        }

        static func sample() -> ViewModel {
            let card1 = Card(name: "Card #1", currencies: ["CZK", "EUR"])
            let card2 = Card(name: "Card #2", currencies: ["EUR", "PLN", "GBP"])
            let card3 = Card(name: "Card #3", currencies: ["EUR"])
            return ViewModel(
                cards: [card1, card2, card3],
                selectedCard: card2,
                selectedCurrency: "EUR",
                specifyAmount: false,
                amount: "1000")
        }
    }

    init() {
        super.init(model: ViewModel.sample())
    }

    override func loadForm() -> Form<ViewModel> {

        let form = Form<ViewModel>()

        form += SelectableSection("Cards", items: \.cards, selectedItem: \.selectedCard)

        form += Section("Currency") {
                $0.bind(\.isVisible, to: \.selectedCard.currencies, through: { $0.count > 1 })
            }
            <<< FormSegmentedCell(items: \.selectedCard.currencies, selectedItem: \.selectedCurrency) {
                $0.bind(\.isVisible, to: \.selectedCard.currencies, through: { $0.count > 1 })
            }

        form += Section()
            <<< FormSwitchCell(keyPath: \.specifyAmount, title: "Specify Amount")
            <<< FormTextFieldCell(keyPath: \.amount) {
                $0.bind(\.isVisible, to: \.specifyAmount)
                $0.textField.placeholder = "Enter amount"
                $0.textField.clearButtonMode = .whileEditing
                $0.textField.keyboardType = .decimalPad
                $0.inputFilter = { text in
                    return text == "" || Double(text) != nil
                }
            }

        form += Section("Summary")
            <<< FormLabelCell(style: .value1, primaryText: "Currency") {
                $0.bind(\.secondaryText, to: \.selectedCurrency)
            }
            <<< FormLabelCell(style: .value1, primaryText: "Amount") {
                $0.bind(\.isVisible, to: \.specifyAmount)
                $0.bind(\.secondaryText, to: \.amount, through: { value in
                    return value?.isEmpty == false ? value : "N/A"
                })
            }

        form += Section()
            <<< FormButtonCell(title: "Pay") {
                $0.bind(\.shouldHighlight, to: \.canBeSubmitted)
                $0.didSelect = {
                    print("Moo!")
                }
            }

        return form
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
