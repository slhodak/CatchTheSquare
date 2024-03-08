import RealityKit


public struct SquareIdentifierComponent: Component, Codable {
    public var row: Int = 0
    public var column: Int = 0
    
    public init(row: Int, column: Int){
        self.row = row
        self.column = column
    }
}
