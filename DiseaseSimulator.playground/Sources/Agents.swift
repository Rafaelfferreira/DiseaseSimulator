import Foundation
import UIKit

public class Agent: UIButton {
    var position: (Int,Int)
    var neighbours: [(line: Int,column: Int)]
    var boardSize: (nLines: Int, nColumns: Int)
    
    var status: agentStatus {
        didSet { //observer that runs this code everytime the value of alive changes
            if status == .inactive {
                self.backgroundColor = Environment.neutralColor
            }
            else if status == .infected {
                self.backgroundColor = Environment.infectedColor
            }
            else if status == .healthy{
                self.backgroundColor = Environment.healthyColor
            }
        }
    }
    
    public init(frame: CGRect, position: (Int,Int), boardSize: (Int, Int)) {
        self.status = .inactive
        self.position = position
        self.boardSize = boardSize
        self.neighbours = []
        super.init(frame: frame)
        self.neighbours = self.findNeighbours(position: position)
    }
    
    
    
    // default required initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func findNeighbours(position: (line: Int,row: Int)) -> [(Int,Int)] {
        var validNeighbours: [(Int, Int)] = []
        for line in (position.line - 2)...(position.line) { //checking the lines above and below the current cell
            if line >= 0 && line < boardSize.nLines { //making sure the line is valid
                for row in (position.row - 2)...(position.row) { //checking the rows before and after the current cell
                    if row >= 0 && row < boardSize.nColumns { //checking that the row is a valid one
                        if line != position.line-1 || row != position.row-1 {
                            validNeighbours.append((line, row))
                        }
                    }
                }
            }
        }
        return validNeighbours
    }
}
