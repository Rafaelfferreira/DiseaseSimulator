import PlaygroundSupport
import UIKit

let board = initiateBoard()
let controller = BoardController(boardView: board)

PlaygroundPage.current.liveView = board
