import Foundation
import UIKit

public class BoardView: UIView {
    
    weak var agentDelegate: agentDelegate? //delegates the actions to be taken when an agent is clicked on
    weak var defaultButtonDelegate: buttonDelegate?
    
     //labels that need to be constantly updated
    var speedValue: Int = 1
    var speedNumber: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
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
        
        //Setting up the UI Buttons
        createDefaultButton(buttonLabel: "Start", posX: 1, posY: 33.5)
        createDefaultButton(buttonLabel: "Clear", posX: 1, posY: 35)
        createRoundButton(buttonLabel: "-", posX: 6.5, posY: 35.1)
        createRoundButton(buttonLabel: "+", posX: 9.5, posY: 35.1)
        
        //Setting the UI Labels
        //setStaticLabel(labelText: "Simulation Speed", posX: 4.5, posY: 32)
        
        //Simulation Speed Label
        var simulationSpeed = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(6.19), y: (CGFloat(33) * buttonSize.height), width: buttonSize.width*5, height: buttonSize.height*2))
        simulationSpeed.text = "Simulation\nspeed"
        simulationSpeed.font = UIFont.boldSystemFont(ofSize: 11)
        simulationSpeed.textColor = Environment.textColor
        simulationSpeed.numberOfLines = 2
        simulationSpeed.textAlignment = .center
        self.addSubview(simulationSpeed)
        
        //setting up the stater value of the speedNumber label
        speedNumber = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(8), y: (CGFloat(35.2) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height))
        speedNumber.text = "1x"
        speedNumber.font = UIFont.boldSystemFont(ofSize: 18)
        speedNumber.textColor = Environment.textColor
        self.addSubview(speedNumber)
        
        
        
        return board
    }
    
    
    func setStaticLabel(labelText: String, posX: Double, posY: Double) {
        var staticLabel = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(posX), y: (CGFloat(posY) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height))
        staticLabel.text = labelText
        staticLabel.font = UIFont.boldSystemFont(ofSize: 11)
        staticLabel.textColor = Environment.textColor
//        staticLabel.numberOfLines = 2
//        staticLabel.textAlignment = .center
        self.addSubview(staticLabel)
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
        if buttonLabel == "Start" {
            returnButton.backgroundColor = Environment.textColor
            returnButton.setTitleColor(UIColor.white, for: .normal)
        }
        self.addSubview(returnButton)
    }
    
    //function that create the + and - rounded buttons
    func createRoundButton(buttonLabel: String, posX: Double, posY: Double) {
        let returnButton = UIButton(frame: CGRect(x: buttonSize.width * CGFloat(posX), y: (CGFloat(posY) * buttonSize.height), width: 1.25 * buttonSize.width, height: buttonSize.height * 1.25))
        //making it rounder
        returnButton.backgroundColor = .clear
        returnButton.layer.cornerRadius = 10
        returnButton.layer.borderWidth = 1
        returnButton.layer.borderColor = Environment.textColor.cgColor//UIColor.black.cgColor
        //adding the text
        returnButton.setTitle(buttonLabel, for: .normal)
        returnButton.backgroundColor = UIColor.white
        returnButton.setTitleColor(Environment.textColor, for: .normal)
        returnButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        returnButton.addTarget(self, action: #selector(buttonDelegate), for: .touchUpInside)
        self.addSubview(returnButton)
    }
    
    // Manda a informacao de qual agente foi clicado atraves do delegate
    @objc func agentClickedNotification(sender: Agent) {
        agentDelegate?.agentClicked(sender)
    }
    
    @objc func buttonDelegate(sender: UIButton) {
        defaultButtonDelegate?.buttonDidPress(sender)
        
        if sender.currentTitle == "-" && speedValue > 1 {
            speedValue -= 1
        }
        else if sender.currentTitle == "+" && speedValue < 5 {
            speedValue += 1
        }
        
        self.speedNumber.text = "\(speedValue)x"
    }
}
