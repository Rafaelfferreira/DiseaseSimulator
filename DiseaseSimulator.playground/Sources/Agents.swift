import Foundation
import UIKit

public class Agent: UIButton {
    var position: (Int,Int)
    var neighbours: [(line: Int,column: Int)]
    var boardSize: (nLines: Int, nColumns: Int)
    var recoveryTime: Int
    var chanceOfDying: Int
    var periodOfDying: Int //represents in which period (in the countdown of recovery time) will the agent die (if he's going to)
    var survivalRoll: Int = 0
    
    var timeUntilRecovery: Int { //starts with one but have to be initialized whenever an agent gets sick
        didSet {
            if timeUntilRecovery == 0 && self.status == .infected{
                self.status = .recovered
            }
        }
    }
    
    var status: agentStatus {
        didSet { //observer that runs this code everytime the value of alive changes
            //print(status)
            switch status {
            case .inactive:
                self.backgroundColor = Environment.neutralColor
            case .infected:
                self.backgroundColor = Environment.infectedColor
                survivalCheck()
            case .healthy:
                self.backgroundColor = Environment.healthyColor
            case .recovered:
                self.backgroundColor = Environment.recoveredColor
            case .willBeOccupied:
                return
            case .dead:
                self.backgroundColor = Environment.deadColor
            }
        }
    }
    
    public init(frame: CGRect, position: (Int,Int), boardSize: (Int, Int), recoveryTime: Int, chanceOfDying: Int) {
        self.status = .inactive
        self.position = position
        self.boardSize = boardSize
        self.neighbours = []
        self.recoveryTime = recoveryTime
        self.chanceOfDying = chanceOfDying
        self.timeUntilRecovery = recoveryTime
        self.periodOfDying = recoveryTime + 1 //starts in a number that will never be achieved, since timeUntilRecovery only goes down
        super.init(frame: frame)
        self.neighbours = self.findNeighbours(position: position)
    }
    
    
    
    // default required initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // checks if the current agent will survive the disease for  another period
    func survivalCheck() {
        survivalRoll = Int.random(in: 1...100) //if the roll is less than the mortalityRate the agent DIES
        if survivalRoll <= chanceOfDying {
            var randomPeriod = Int.random(in: 1...((recoveryTime/3)*2))
            self.periodOfDying = randomPeriod
        }
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
