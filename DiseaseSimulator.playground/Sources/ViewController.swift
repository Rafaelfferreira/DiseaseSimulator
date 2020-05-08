

import Foundation
import UIKit

public class BoardController {
    var board: [[Agents]]
    
    public init(board: BoardView) {
        self.board = [] //Mudar isso aqui para o metodo que inicializa os quadradinhos
    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}

//function that starts the playground view, this happens in a function to hide the view creation from the user
public func initiateBoard() -> UIView{
    let view = UIView(frame: CGRect(x: 20, y: 0, width: 480, height: 600))
    return view
}
