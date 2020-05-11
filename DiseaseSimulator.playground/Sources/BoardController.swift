

import Foundation
import UIKit

public class BoardController: agentDelegate {
    var board: [[Agent]]
    
    public init(boardView: BoardView) {
        self.board = boardView.initBoard() //Mudar isso aqui para o metodo que inicializa os quadradinhos
        boardView.agentDelegate = self
    }
    
    func agentClicked(_ button: Agent) {
        button.infected = !button.infected
    }
    
}

protocol agentDelegate: class {
    func agentClicked(_ button: Agent)
}

//function that starts the playground view, this happens in a function to hide the view creation from the user
public func initiateBoard() -> BoardView{
    let view = BoardView(frame: CGRect(x: 20, y: 0, width: 480, height: 600))
    return view
}
