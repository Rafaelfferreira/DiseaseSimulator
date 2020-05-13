

import Foundation
import UIKit

public class BoardController: agentDelegate, buttonDelegate {
    
    // variables concerning the functioning of the simulation
    var board: [[Agent]]
    public var isRunning: Bool = false
    public var speed: Double = 1 //speed of the game evolution
    var update: [(Int,Int,agentStatus)] = [] //an array that store the coordinates of all the dead cells that sould live
    
    // specific variables regarding the parametr of the simulation
    var transmissionRate: Int = 70
    
    public init(boardView: BoardView) {
        self.board = boardView.initBoard() //Mudar isso aqui para o metodo que inicializa os quadradinhos
        boardView.agentDelegate = self
        boardView.defaultButtonDelegate = self
    }
    
    func agentClicked(_ button: Agent) {
        if button.status == .inactive {
            button.status = .healthy
        }
        else if button.status == .infected {
            button.status = .healthy
        }
        else if button.status == .healthy{
            button.status = .infected
        }
    }
    
    func buttonDidPress(_ button: UIButton) {
        guard let kind = button.currentTitle else { return }
        
        // Tratando qual botao foi clickado
        switch (kind) {
        case "Start":
            isRunning = !isRunning
            start()
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
        //scans the board and find which cells would change
        //the indexes inside the for represent their index in the array, the other part (line or column) is the object in that position
        for (lineIndex, line) in board.enumerated() { //goes through each line
            for (columnIndex, column) in line.enumerated() { //goes through each column, column is the Agent in case
                if column.status == .infected || column.status == .healthy { //randomly moves the squares
                    if column.status == .healthy {
                        checkSickNeighbours(agent: column)
                    }
                    moveRandomly(agent: column)
                }
            }
        }
        
        updateBoard()
    }
    
    //funcao que calcula os movimentos aleatorios dos agentes, apaga os agentes mortos na hora e salva as novas posicoes para serem atualizadas no array "update"
    func moveRandomly(agent: Agent) {
        let currentStatus = agent.status
        let direction = Int.random(in: 0 ... 3)
        
        
        switch (direction) {
        case 0: //Up
            if (agent.position.0 > 0) && (board[agent.position.0 - 1][agent.position.1].status == .inactive){
                board[agent.position.0][agent.position.1].status = .inactive
                board[agent.position.0 - 1][agent.position.1].status = .willBeOccupied
                self.update.append((agent.position.0 - 1 , agent.position.1 , currentStatus))
            }
        case 1: //Right
            if (agent.position.1 < 45) && (board[agent.position.0][agent.position.1 + 1].status == .inactive){
                board[agent.position.0][agent.position.1].status = .inactive
                board[agent.position.0][agent.position.1 + 1].status = .willBeOccupied
                self.update.append((agent.position.0 , agent.position.1 + 1, currentStatus))
            }
        case 2: //Down
            if (agent.position.0 < 45) && (board[agent.position.0 + 1][agent.position.1].status == .inactive){
                board[agent.position.0][agent.position.1].status = .inactive
                board[agent.position.0 + 1][agent.position.1].status = .willBeOccupied
                self.update.append((agent.position.0 + 1 , agent.position.1 , currentStatus))
            }
        case 3: //Left
            if (agent.position.1 > 0) && (board[agent.position.0][agent.position.1 - 1].status == .inactive){
                board[agent.position.0][agent.position.1].status = .inactive
                board[agent.position.0][agent.position.1 - 1].status = .willBeOccupied
                self.update.append((agent.position.0 , agent.position.1 - 1, currentStatus))
            }
        default:
            return
        }
    }
    
    //atualiza o tabuleiro com os dados dentro do array update
    func updateBoard() {
        for agent in update {
            board[agent.0][agent.1].status = agent.2
        }
        
        update = []
    }
    
    public func checkSickNeighbours(agent: Agent){ //check among the neighbours of the cell if one of them is sick
        var gotInfected: Bool = false //if the current agent already got infected we can stop the checking neighbour process
        for neighbour in agent.neighbours {
            if gotInfected == false { //doesnt check the other neighbors status if the agent already got infected
                if board[neighbour.line][neighbour.column].status == .infected {
                    let healthyRoll = Int.random(in: 1...100) //if the roll is less than the transmissionRate the agent gets infected
                    if healthyRoll <= transmissionRate {
                        agent.status = .infected
                        gotInfected = true
                    }
                }
            }
        }
    }
}

protocol agentDelegate: class {
    func agentClicked(_ button: Agent)
}

protocol buttonDelegate: class {
    func buttonDidPress(_ button: UIButton)
}

//function that starts the playground view, this happens in a function to hide the view creation from the user
public func initiateBoard() -> BoardView{
    let view = BoardView(frame: CGRect(x: 20, y: 0, width: 480, height: 600))
    return view
}
