

import Foundation
import UIKit

public class BoardController: agentDelegate, buttonDelegate {
    
    weak var statusUpdateDelegate: statusUpdateDelegate? //delegates the actions to be taken when an agent is clicked on
    
    // variables concerning the functioning of the simulation
    var board: [[Agent]]
    public var isRunning: Bool = false
    public var speed: Double = 1 //speed of the game evolution
    var update: [(Int,Int,agentStatus,Int, Int, Int)] = [] //an array that store the information of the cells that are moving
    
    // specific variables regarding the parameters of the simulation
    var transmissionRate: Int = 70 //the chances of a heathy agent contract the disease by interacting with a sick one
    var recoveryTime: Int = 20 //how many periods does an agent remains sick
    var mortalityRate: Int = 30 //what are the chances that an infected person wil die
    var canReinfect: Bool = false
    
    // var that keep control of the status of the board
    var healthyNumbers : Int = 0
    var infectedNumbers : Int = 0
    var recoveredNumbers : Int = 0
    var deceasedNumbers : Int = 0
    
    
    public init(boardView: BoardView) {
        self.board = boardView.initBoard(agentsRecoveryTime: recoveryTime, agentsMortalityRate: mortalityRate) //Mudar isso aqui para o metodo que inicializa os quadradinhos
        boardView.agentDelegate = self
        boardView.defaultButtonDelegate = self
        self.statusUpdateDelegate = boardView
    }
    
    func agentClicked(_ button: Agent) {
        if button.status == .inactive {
            button.status = .healthy
            healthyNumbers += 1
        }
        else if button.status == .infected {
            button.status = .healthy
            infectedNumbers -= 1
            healthyNumbers += 1
        }
        else if button.status == .healthy{
            button.status = .infected
            button.timeUntilRecovery = recoveryTime
            button.survivalCheck(currentRecoveryTime: recoveryTime)
            healthyNumbers -= 1
            infectedNumbers += 1
        }
        
        statusUpdateDelegate?.updateData(healthy: healthyNumbers, infected: infectedNumbers, recovered: recoveredNumbers, deceased: deceasedNumbers)
    }
    
    func buttonDidPress(_ button: MyButton) {
        guard let kind = button.id else { return }
        
        // Tratando qual botao foi clickado
        switch (kind) {
        case "Start":
            isRunning = !isRunning
            start()
        case "Clear":
            clearBoard()
        case "reduceSpeed":
            if speed > 1 {
                speed -= 1
            }
        case "increaseSpeed":
            if speed < 5 {
                speed += 1
            }
        case "reduceTransmission":
            if transmissionRate > 0 {
                transmissionRate -= 10
            }
        case "increaseTransmission":
            if transmissionRate < 100 {
                transmissionRate += 10
            }
        case "reduceRecovery":
            if recoveryTime > 5 {
                recoveryTime -= 5
            }
        case "increaseRecovery":
            if recoveryTime < 40 {
                recoveryTime += 5
            }
        case "increaseMortality":
            if mortalityRate < 100 {
                mortalityRate += 10
            }
        case "reduceMortality":
            if mortalityRate > 0 {
                mortalityRate -= 10
            }
        case "enableReinfection":
            canReinfect = true
        case "disableReinfection":
            canReinfect = false
        default:
            print("invalid button pressed")
        }
    }
    
    //Starts the auto running on the program
    public func start() {
        if isRunning {
            step()
            DispatchQueue.main.asyncAfter(deadline: .now() + (1/(1.5*speed))) { //Faz uma autochamada apos passar determinado tempo
                self.start()
            }
        }
    }
    
    //simulates one step on the board
    public func step() {
//        print(mortalityRate)
        //scans the board and find which cells would change
        //the indexes inside the for represent their index in the array, the other part (line or column) is the object in that position
        for (_, line) in board.enumerated() { //goes through each line
            for (_, column) in line.enumerated() { //goes through each column, column is the Agent in case
                if column.status == .infected || column.status == .healthy || column.status == .recovered { //randomly moves the squares
                    if column.status == .healthy || (canReinfect && column.status == .recovered ){
                        checkSickNeighbours(agent: column)
                    } else if column.timeUntilRecovery > 0 { //O agente esta infectado com a doenca
                        column.timeUntilRecovery -= 1
                        if column.timeUntilRecovery == column.periodOfDying && column.survivalRoll < mortalityRate {
                            print("\(column.survivalRoll) < \(mortalityRate)")
                            column.status = .dead
                            infectedNumbers -= 1
                            deceasedNumbers += 1
                        }
                    } else if column.timeUntilRecovery == 0 && column.status == .infected{
                        column.status = .recovered
                        recoveredNumbers += 1
                    }
                    moveRandomly(agent: column)
                }
            }
        }
        
        updateBoard()
        statusUpdateDelegate?.updateData(healthy: healthyNumbers, infected: infectedNumbers, recovered: recoveredNumbers, deceased: deceasedNumbers)
    }
    
    public func checkSickNeighbours(agent: Agent){ //check among the neighbours of the cell if one of them is sick
        var gotInfected: Bool = false //if the current agent already got infected we can stop the checking neighbour process
        for neighbour in agent.neighbours {
            if gotInfected == false { //doesnt check the other neighbors status if the agent already got infected
                if board[neighbour.line][neighbour.column].status == .infected {
                    let healthyRoll = Int.random(in: 1...100) //if the roll is less than the transmissionRate the agent gets infected
                    if healthyRoll <= transmissionRate {
                        agent.status = .infected
                        agent.survivalCheck(currentRecoveryTime: recoveryTime)
                        agent.timeUntilRecovery = recoveryTime
                        gotInfected = true
                    }
                }
            }
        }
    }
    
    //funcao que calcula os movimentos aleatorios dos agentes, apaga os agentes mortos na hora e salva as novas posicoes para serem atualizadas no array "update"
    func moveRandomly(agent: Agent) {
        let currentStatus = agent.status
        let direction = Int.random(in: 0 ... 3)
        print(agent.survivalRoll)
        
        switch (direction) {
        case 0: //Up
            if (agent.position.0 > 0) && (board[agent.position.0 - 1][agent.position.1].status == .inactive){
                board[agent.position.0][agent.position.1].status = .inactive
                board[agent.position.0 - 1][agent.position.1].status = .willBeOccupied
                self.update.append((agent.position.0 - 1 , agent.position.1 , currentStatus, agent.timeUntilRecovery, agent.periodOfDying, agent.survivalRoll))
            }
        case 1: //Right
            if (agent.position.1 < Environment.nColumns - 1) && (board[agent.position.0][agent.position.1 + 1].status == .inactive){
                board[agent.position.0][agent.position.1].status = .inactive
                board[agent.position.0][agent.position.1 + 1].status = .willBeOccupied
                self.update.append((agent.position.0 , agent.position.1 + 1, currentStatus, agent.timeUntilRecovery, agent.periodOfDying, agent.survivalRoll))
            }
        case 2: //Down
            if (agent.position.0 < Environment.nLines - 1) && (board[agent.position.0 + 1][agent.position.1].status == .inactive){
                board[agent.position.0][agent.position.1].status = .inactive
                board[agent.position.0 + 1][agent.position.1].status = .willBeOccupied
                self.update.append((agent.position.0 + 1 , agent.position.1 , currentStatus, agent.timeUntilRecovery, agent.periodOfDying, agent.survivalRoll))
            }
        case 3: //Left
            if (agent.position.1 > 0) && (board[agent.position.0][agent.position.1 - 1].status == .inactive){
                board[agent.position.0][agent.position.1].status = .inactive
                board[agent.position.0][agent.position.1 - 1].status = .willBeOccupied
                self.update.append((agent.position.0 , agent.position.1 - 1, currentStatus, agent.timeUntilRecovery, agent.periodOfDying, agent.survivalRoll))
            }
        default:
            return
        }
    }
    
    //atualiza o tabuleiro com os dados dentro do array update
    func updateBoard() {
        for agent in update {
            board[agent.0][agent.1].status = agent.2
            board[agent.0][agent.1].timeUntilRecovery = agent.3
            board[agent.0][agent.1].periodOfDying = agent.4
            board[agent.0][agent.1].survivalRoll = agent.5
        }
        
        update = []
    }
    
    func clearBoard() {
        var kill: [(line: Int, column: Int)] = [] //an array that store the coordinates of all the alive cells that should die
        
        for (lineIndex, line) in self.board.enumerated() { //goes through each line
            for (columnIndex, column) in line.enumerated() {
                if column.status != .inactive {
                    kill.append((line: lineIndex, column: columnIndex))
                }
            }
        }
        
        //changes alive cells to dead when appropriate
        for agent in kill {
            board[agent.line][agent.column].status = .inactive
            board[agent.line][agent.column].timeUntilRecovery = recoveryTime
            board[agent.line][agent.column].periodOfDying = recoveryTime + 1
        }
        
        kill = []
    }
}

//function that starts the playground view, this happens in a function to hide the view creation from the user
public func initiateBoard() -> BoardView{
    let view = BoardView(frame: CGRect(x: 20, y: 0, width: 480, height: 600))
    return view
}

protocol statusUpdateDelegate: class {
    func updateData(healthy: Int, infected: Int, recovered: Int, deceased: Int)
}

protocol agentDelegate: class {
    func agentClicked(_ button: Agent)
}

protocol buttonDelegate: class {
    func buttonDidPress(_ button: MyButton)
}
