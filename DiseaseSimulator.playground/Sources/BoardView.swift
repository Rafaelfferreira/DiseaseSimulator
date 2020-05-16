import Foundation
import UIKit

public class BoardView: UIView {
    
    weak var agentDelegate: agentDelegate? //delegates the actions to be taken when an agent is clicked on
    weak var defaultButtonDelegate: buttonDelegate?
    
     //labels that need to be constantly updated
    var speedValue: Int = 1  // logical value
    var speedNumber: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0)) //actual label
    var transmissionValue: Int = 70
    var transmissionLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var recoveryTimeValue: Int = 20
    var recoveryTimeLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var mortalityRateValue: Int = 30
    var mortalityRateLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var canReinfect: Bool = false
    
    var enableReinfectionButton: MyButton = MyButton()
    var disableReinfectionButton: MyButton = MyButton()
    
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
        
        //LEFT SIDE UI - SIMULATION CONTROL
        createDefaultButton(buttonLabel: "Start", buttonID: "Start", posX: 1, posY: 31.9)
        createDefaultButton(buttonLabel: "Clear", buttonID: "Clear", posX: 1, posY: 33.4)
        setStaticLabel(labelText: "Speed", posX: 2.2, posY: 34.75, color: UIColor.black)
        createRoundButton(buttonLabel: "-", buttonID: "reduceSpeed", posX: 1, posY: 35.75, color: UIColor.black)
        createRoundButton(buttonLabel: "+", buttonID: "increaseSpeed", posX: 4.2, posY: 35.75, color: UIColor.black)
        speedNumber = setDynamicLabel(labelText: "1x", posX: 2.7, posY: 35.85, size: 16, color: UIColor.black)
        self.addSubview(speedNumber)
        
        //MIDDLE UI - SIMULATION PARAMETERS
        transmissionLabel = setParameterControl(parameterName: "Transmission Rate", buttonID: "Transmission", parameterValue: transmissionValue, posX: 7, posY: 31.5)
        self.addSubview(transmissionLabel)
        recoveryTimeLabel = setParameterControl(parameterName: "Recovery Time", buttonID: "Recovery", parameterValue: recoveryTimeValue, posX: 7, posY: 33)
        recoveryTimeLabel.text = "\(recoveryTimeValue) steps"
        recoveryTimeLabel.frame.origin.x -= 15
        self.addSubview(recoveryTimeLabel)
        mortalityRateLabel = setParameterControl(parameterName: "Mortality Rate", buttonID: "Mortality", parameterValue: mortalityRateValue, posX: 7, posY: 34.5)
        self.addSubview(mortalityRateLabel)
        setStaticLabel(labelText: "Reinfection", posX: 7, posY: 36, size: 13)
        createReinfectionButton(posX: 16, posY: 36, color: UIColor.black)
        
        //RIGHT SIDE UI - SIMULATION STATUS
        //FIX ME: - UI labels refering to the status of the simulation - Not currently updated
        setStaticLabel(labelText: "Status:", posX: 23.8, posY: 31.7, size: 15, color: UIColor.black)
        setStaticLabel(labelText: "Healthy: 1010", posX: 23, posY: 32.8, color: Environment.healthyColor)
        setStaticLabel(labelText: "Infected: 1000", posX: 23, posY: 33.8, color: Environment.infectedColor)
        setStaticLabel(labelText: "Recovered: 1000", posX: 23, posY: 34.8, color: Environment.recoveredColor)
        setStaticLabel(labelText: "Deceased: 1000", posX: 23, posY: 35.8, color: Environment.deadColor)
        
        return board
    }
    
    func setParameterControl(parameterName: String, buttonID: String, parameterValue: Int , posX: Double, posY: Double) -> UILabel {
        setStaticLabel(labelText: parameterName, posX: posX, posY: posY, size: 13)
        createRoundButton(buttonLabel: "-", buttonID: "reduce\(buttonID)", posX: posX + 7.75, posY: posY - 0.1, color: UIColor.black)
        createRoundButton(buttonLabel: "+", buttonID: "increase\(buttonID)", posX: posX + 13.4, posY: posY - 0.1, color: UIColor.black)
        return setDynamicLabel(labelText: "\(parameterValue)%", posX: posX + 10.45, posY: posY, size: 13, color: UIColor.black)
    }
    
    func setDynamicLabel(labelText: String, posX: Double, posY: Double, size: CGFloat = 11, color: UIColor = Environment.textColor) -> UILabel {
        let dynamicLabel = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(posX), y: (CGFloat(posY) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height))
        dynamicLabel.text = labelText
        dynamicLabel.font = UIFont.boldSystemFont(ofSize: size)
        dynamicLabel.textColor = color
        
        return dynamicLabel
    }
    
    func setStaticLabel(labelText: String, posX: Double, posY: Double, size: CGFloat = 11, color: UIColor = Environment.textColor) {
        let staticLabel = UILabel(frame: CGRect(x: buttonSize.width * CGFloat(posX), y: (CGFloat(posY) * buttonSize.height), width: buttonSize.width*20, height: buttonSize.height))
        staticLabel.text = labelText
        staticLabel.font = UIFont.boldSystemFont(ofSize: size)
        staticLabel.textColor = color
        self.addSubview(staticLabel)
    }
    
    //function that creates buttons with the default style of this playground.
    //the X and Y positions are relative to the width and the height of the cells
    func createDefaultButton(buttonLabel: String, buttonID: String, posX: Double, posY: Double, color: UIColor = Environment.textColor){ //-> UIButton{
        let returnButton = MyButton(frame: CGRect(x: buttonSize.width * CGFloat(posX), y: (CGFloat(posY) * buttonSize.height), width: 4.5 * buttonSize.width, height: buttonSize.height * 1.25))
        //making it rounder
        returnButton.backgroundColor = .clear
        returnButton.layer.cornerRadius = 5
        returnButton.layer.borderWidth = 1
        returnButton.layer.borderColor = UIColor.black.cgColor//Environment.textColor.cgColor
        //adding the text
        returnButton.setTitle(buttonLabel, for: .normal)
        returnButton.backgroundColor = UIColor.white
        returnButton.setTitleColor(color, for: .normal)
        returnButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        returnButton.id = buttonID
        returnButton.addTarget(self, action: #selector(buttonDelegate), for: .touchUpInside)
        if buttonID == "Start" {
            returnButton.backgroundColor = Environment.textColor
            returnButton.setTitleColor(UIColor.white, for: .normal)
        }
        self.addSubview(returnButton)
    }
    
    //function that create the + and - rounded buttons
    func createRoundButton(buttonLabel: String, buttonID: String, posX: Double, posY: Double, color: UIColor = Environment.textColor) {
        let returnButton = MyButton(frame: CGRect(x: buttonSize.width * CGFloat(posX), y: (CGFloat(posY) * buttonSize.height), width: 1.25 * buttonSize.width, height: buttonSize.height * 1.25))
        //making it rounder
        returnButton.backgroundColor = .clear
        returnButton.layer.cornerRadius = 10
        returnButton.layer.borderWidth = 1
        returnButton.layer.borderColor = color.cgColor//UIColor.black.cgColor
        //adding the text
        returnButton.setTitle(buttonLabel, for: .normal)
        returnButton.backgroundColor = UIColor.white
        returnButton.setTitleColor(color, for: .normal)
        returnButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        returnButton.id = buttonID
        returnButton.addTarget(self, action: #selector(buttonDelegate), for: .touchUpInside)
        self.addSubview(returnButton)
    }
    
    func createReinfectionButton(posX: Double, posY: Double, color: UIColor = Environment.textColor) {
        enableReinfectionButton = MyButton(frame: CGRect(x: buttonSize.width * CGFloat(posX), y: (CGFloat(posY) * buttonSize.height), width: 2 * buttonSize.width, height: buttonSize.height * 1.25))
        //making it rounder
        enableReinfectionButton.backgroundColor = .clear
        enableReinfectionButton.layer.cornerRadius = 5
        enableReinfectionButton.layer.borderWidth = 1
        enableReinfectionButton.layer.borderColor = color.cgColor//UIColor.black.cgColor
        //adding the text
        enableReinfectionButton.setTitle("Yes", for: .normal)
        enableReinfectionButton.backgroundColor = UIColor.white
        enableReinfectionButton.setTitleColor(color, for: .normal)
        enableReinfectionButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        enableReinfectionButton.id = "enableReinfection"
        enableReinfectionButton.addTarget(self, action: #selector(buttonDelegate), for: .touchUpInside)
        self.addSubview(enableReinfectionButton)
       
        disableReinfectionButton = MyButton(frame: CGRect(x: buttonSize.width * CGFloat(posX + 2.5), y: (CGFloat(posY) * buttonSize.height), width: 2 * buttonSize.width, height: buttonSize.height * 1.25))
        //making it rounder
        disableReinfectionButton.backgroundColor = .clear
        disableReinfectionButton.layer.cornerRadius = 5
        disableReinfectionButton.layer.borderWidth = 1
        disableReinfectionButton.layer.borderColor = color.cgColor//UIColor.black.cgColor
        //adding the text
        disableReinfectionButton.setTitle("No", for: .normal)
        disableReinfectionButton.backgroundColor = Environment.textColor
        disableReinfectionButton.setTitleColor(UIColor.white, for: .normal)
        disableReinfectionButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        disableReinfectionButton.id = "disableReinfection"
        disableReinfectionButton.addTarget(self, action: #selector(buttonDelegate), for: .touchUpInside)
        self.addSubview(disableReinfectionButton)
    }
    
    // Manda a informacao de qual agente foi clicado atraves do delegate
    @objc func agentClickedNotification(sender: Agent) {
        agentDelegate?.agentClicked(sender)
    }
    
    @objc func buttonDelegate(sender: MyButton) {
        defaultButtonDelegate?.buttonDidPress(sender)
        
        if sender.id == "reduceSpeed" && speedValue > 1 {
            speedValue -= 1
        } else if sender.id == "increaseSpeed" && speedValue < 5 {
            speedValue += 1
        } else if sender.id == "increaseTransmission" && transmissionValue < 100 {
            transmissionValue += 10
            if transmissionValue == 100 { //adjusts the label to the left so to keep the 100% centered
                self.transmissionLabel.frame.origin.x -= 4
            }
        } else if sender.id == "reduceTransmission" && transmissionValue > 0 {
            if transmissionValue == 100 { //adjusts the label to the right to keep it centered
                self.transmissionLabel.frame.origin.x += 4
            }
            transmissionValue -= 10
        } else if sender.id == "increaseRecovery" && recoveryTimeValue < 40 {
            if recoveryTimeValue == 5 {
                self.recoveryTimeLabel.frame.origin.x -= 4
            }
            recoveryTimeValue += 5
        } else if sender.id == "reduceRecovery" && recoveryTimeValue > 5 {
            recoveryTimeValue -= 5
            if recoveryTimeValue == 5 {
                self.recoveryTimeLabel.frame.origin.x += 4
            }
        } else if sender.id == "increaseMortality" && mortalityRateValue < 100 {
            if mortalityRateValue == 0 {
                self.mortalityRateLabel.frame.origin.x -= 4
            }
            mortalityRateValue += 10
        } else if sender.id == "reduceMortality" && mortalityRateValue > 5 {
            mortalityRateValue -= 10
            if mortalityRateValue == 0 {
                self.mortalityRateLabel.frame.origin.x += 4
            }
        } else if sender.id == "enableReinfection" {
            enableReinfectionButton.backgroundColor = Environment.textColor
            enableReinfectionButton.setTitleColor(UIColor.white, for: .normal)
//            disableReinfectionButton.layer.borderColor = UIColor.black.cgColor
            disableReinfectionButton.backgroundColor = UIColor.white
            disableReinfectionButton.setTitleColor(UIColor.black, for: .normal)
            
        } else if sender.id == "disableReinfection" {
//            enableReinfectionButton.layer.borderColor = UIColor.black.cgColor
            enableReinfectionButton.backgroundColor = UIColor.white
            enableReinfectionButton.setTitleColor(UIColor.black, for: .normal)
            
//            disableReinfectionButton.layer.borderColor = UIColor.black.cgColor
            disableReinfectionButton.backgroundColor = Environment.textColor
            disableReinfectionButton.setTitleColor(UIColor.white, for: .normal)
        }
        
        self.speedNumber.text = "\(speedValue)x"
        self.transmissionLabel.text = "\(transmissionValue)%"
        self.recoveryTimeLabel.text = "\(recoveryTimeValue) steps"
        self.mortalityRateLabel.text = "\(mortalityRateValue)%"
    }
}

class MyButton: UIButton {
    var id: String?
}
