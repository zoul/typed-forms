import UIKit

struct Card: Equatable, CustomStringConvertible {

    let name: String
    let currencies: [String]

    var description: String {
        return name
    }
}

struct CardSelectionModel {

    var cards: [Card]
    var selectedCard: Card {
        didSet {
            selectedCurrency = selectedCard.currencies.first!
        }
    }
    var selectedCurrency: String
    var specifyAmount: Bool
}

class ViewController: FormViewController<CardSelectionModel> {

    init() {

        let card1 = Card(name: "Card #1", currencies: ["CZK", "EUR"])
        let card2 = Card(name: "Card #2", currencies: ["EUR", "PLN", "GBP"])
        let card3 = Card(name: "Card #3", currencies: ["EUR"])
        let model = CardSelectionModel(
            cards: [card1, card2, card3], selectedCard: card2,
            selectedCurrency: "EUR", specifyAmount: false)

        let form = Form<CardSelectionModel>()

        form += SelectableSection("Cards", items: \.cards, selectedItem: \.selectedCard)

        form += Section("Currency")
            <<< FormSegmentedCell(items: \.selectedCard.currencies, selectedItem: \.selectedCurrency)

        form += Section()
            <<< FormSwitchCell(keyPath: \.specifyAmount, title: "Specify Amount")
            <<< FormLabelCell(title: "TODO: Add input") {
                $0.visible = \.specifyAmount
                $0.textLabel?.textColor = .gray
            }

        super.init(model: model, form: form)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
