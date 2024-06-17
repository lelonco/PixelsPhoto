import GenericCollection

typealias ConfigurableCell = BaseConfigurableCell & CellCreatable

protocol CellCreatable {
    static var cellCreator: any CellCreator { get }
}
