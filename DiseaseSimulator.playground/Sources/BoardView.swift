import Foundation
import UIKit

public class BoardView: UIView {
    
    weak var agentDelegate: agentDelegate? //delegates the actions to be taken when an agent is clicked on
    
    let buttonSize = CGSize(width: Int(Environment.screenWidth)/Environment.proportionGrid, height: Int(Environment.screenHeight)/Environment.proportionGrid)
    
    func initBoard() -> [[Agent]] {
        var board: [[Agent]] = []
        
        //initializing the current line of agents
        for line in 1...(Environment.nLines) {
            var columnButtons: [Agent] = []
            
            //initializing the current row of agents
            for column in 1...(Environment.nColumns) {
                let button = Agent(frame: CGRect(x: (buttonSize.width * CGFloat(column)), y: (CGFloat(3 + line) * buttonSize.height), width: buttonSize.width, height: buttonSize.height), position: (line,column), boardSize: (Environment.nLines, Environment.nColumns))
                
                button.position = (line, column)
                button.backgroundColor = .green
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.red.cgColor
                button.addTarget(self, action: #selector(agentClickedNotification), for: .touchUpInside) //allows the user to change the button state
                
                columnButtons.append(button)
                self.addSubview(button)
            }
            board.append(columnButtons)
        }
        
        return board
    }
    
    // Change the status of the button if the player clicks on it
    @objc func agentClicked(sender: Agent) {
        sender.infected = !sender.infected
    }
    
    // Manda a informacao de qual agente foi clicado atraves do delegate
    @objc func agentClickedNotification(sender: Agent) {
        agentDelegate?.agentClicked(sender)
    }
    
}
