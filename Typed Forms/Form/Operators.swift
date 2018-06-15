import Foundation

precedencegroup SectionPrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
}

infix operator <<< : SectionPrecedence

@discardableResult
func <<< <Model> (lhs: Section<Model>, rhs: FormCell<Model>) -> Section<Model> {
    lhs.addCell(rhs)
    return lhs
}

func += <Model> (lhs: Form<Model>, rhs: Section<Model>) {
    lhs.addSection(rhs)
}
