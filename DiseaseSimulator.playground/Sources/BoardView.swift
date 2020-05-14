import Foundation
import UIKit

public class BoardView: UIView {
    
    weak var agentDelegate: agentDelegate? //delegates the actions to be taken when an agent is clicked on
    weak var defaultButtonDelegate: buttonDelegate?
    
    let agentSize = CGSize(width: Int(Environment.screenWidth)/Environment.proportionGrid, height: Int(Environment.screenHeight)/Environment.proportionGrid)
    let buttonSize = CGSize(width: Int(Environment.screenWidth)/Environment.proportionButton, height: Int(Environment.screenHeight)/Environment.proportionButton)
    
    
    func initBoard(agentsRecoveryTime: Int, agentsMortalityRate: Int) -> [[Agent]] {
        var board: [[Agent]] = []
        
        //initializing the current line of agents
        for line in 1...(Environment.nLines) {
            var columnButtons: [Agent] = []
            
            //initializing the current row of agents
            for column in 1...(Environment.nColumns) {
                let button = Agent(frame: CGRect(x: (agentSize.width * CGFloat(column)), y: (CGFloat(3 + line) * agentSize.height), width: agentSize.width, height: agentSize.height), position: (line,column), boardSize: (Environment.nLines, Environment.nColumns), recoveryTime: agentsRecoveryTime, chanceOfDying: agentsMortalityRate)
                
                button.position = (line-1, column-1)
                button.backgroundColor = Environment.neutralColor
                button.layer.borderWidth = 0.5
                button.layer.borderColor = UIColor.white.cgColor
                button.layer.cornerRadius = 2
                button.addTarget(self, action: #selector(agentClickedNotification), for: .touchUpInside) //allows the user to change the button state
                
                columnButtons.append(button)
                self.addSubview(button)
            }
            board.append(columnButtons)
        }
        
        createDefaultButton(buttonLabel: "Start", posX: 1, posY: 1)
        
        return board
    }
    
    
    //function that creates buttons with the default style of this playground.
    //the X and Y positions are relative to the width and the height of the cells
    func createDefaultButton(buttonLabel: String, posX: Double, posY: Double){ //-> UIButton{
        let returnButton = UIButton(frame: CGRect(x: buttonSize.width * CGFloat(posX), y: (CGFloat(posY) * buttonSize.height), width: 4.5 * buttonSize.width, height: buttonSize.height * 1.25))
        //making it rounder
        returnButton.backgroundColor = .clear
        returnButton.layer.cornerRadius = 5
        returnButton.layer.borderWidth = 1
        returnButton.layer.borderColor = Environment.textColor.cgColor//UIColor.black.cgColor
        //adding the text
        returnButton.setTitle(buttonLabel, for: .normal)
        returnButton.backgroundColor = UIColor.white
        returnButton.setTitleColor(Environment.textColor, for: .normal)
        returnButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        returnButton.addTarget(self, action: #selector(buttonDelegate), for: .touchUpInside)
        if buttonLabel == "Play" {
            returnButton.backgroundColor = Environment.textColor
            returnButton.setTitleColor(UIColor.white, for: .normal)
        }
        self.addSubview(returnButton)
    }
    
    // Manda a informacao de qual agente foi clicado atraves do delegate
    @objc func agentClickedNotification(sender: Agent) {
        agentDelegate?.agentClicked(sender)
    }
    
    @objc func buttonDelegate(sender: UIButton) {
        defaultButtonDelegate?.buttonDidPress(sender)
    }
}
