/*: ## ***Overview***
 This playground was designed to help people understand and visualize the consequences and the dangers of how an infectious disease can quickly spread and the impact it can have on a community.
 
 It is a basic simulation of multiple subjects randomly leading their lives, the user can then choose how many (and which) subjects are infected with the disease and simulate how it will spread. The aim is for the user to change the parameters and see how the simulation reacts so to get a better understanding of how epidemics usually happen in the real world. To start, just run the code below that initializes the board:
 */
import PlaygroundSupport
import UIKit

let board = initiateBoard()
let controller = BoardController(boardView: board)

PlaygroundPage.current.liveView = board

/*:
#### How does it work?
 
 
*/
