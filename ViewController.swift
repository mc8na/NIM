//
//  ViewController.swift
//  NIM2.0
//
//  Created by Miles Clikeman on 5/5/19.
//  Copyright © 2019 Miles Clikeman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nimtitle: UILabel!
    @IBOutlet weak var gameplaymenubutton: UIButton!
    @IBOutlet weak var player1menubutton: UIButton!
    @IBOutlet weak var player2menubutton: UIButton!
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var gameplayinstructions: UITextView!
    @IBOutlet weak var mainmenupage: UIView!
    
    @IBOutlet weak var difficultyselectionview: UIView!
    @IBOutlet weak var easybutton: UIButton!
    @IBOutlet weak var hardbutton: UIButton!
    
    @IBOutlet weak var boardview: UIView!
    @IBOutlet weak var stick0: UIButton!
    @IBOutlet weak var stick1: UIButton!
    @IBOutlet weak var stick2: UIButton!
    @IBOutlet weak var stick3: UIButton!
    @IBOutlet weak var stick4: UIButton!
    @IBOutlet weak var stick5: UIButton!
    @IBOutlet weak var stick6: UIButton!
    @IBOutlet weak var stick7: UIButton!
    @IBOutlet weak var stick8: UIButton!
    @IBOutlet weak var stick9: UIButton!
    @IBOutlet weak var stick10: UIButton!
    @IBOutlet weak var stick11: UIButton!
    @IBOutlet weak var stick12: UIButton!
    @IBOutlet weak var stick13: UIButton!
    @IBOutlet weak var stick14: UIButton!
    @IBOutlet weak var stick15: UIButton!
    @IBOutlet weak var arrowbutton: UIButton!
    @IBOutlet weak var player1label: UILabel!
    @IBOutlet weak var player2label: UILabel!
    @IBOutlet weak var cpulabel: UILabel!
    
    @IBOutlet weak var playfirstorsecondview: UIView!
    @IBOutlet weak var firstbutton: UIButton!
    @IBOutlet weak var secondbutton: UIButton!
    
    @IBOutlet weak var gameoverview: UIView!
    @IBOutlet weak var player1wins: UILabel!
    @IBOutlet weak var player2wins: UILabel!
    @IBOutlet weak var cpuwins: UILabel!
    @IBOutlet weak var newgamebutton: UIButton!
    @IBOutlet weak var mainmenubutton: UIButton!
    
    var sticks: [UIButton] = [UIButton]()
    
    var isSelected : [Bool] = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
    
    var isRemoved : [Bool] = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
    
    var numSticksInRow : [Int] = [1,3,5,7]
    
    var isOnePlayerGame : Bool = false
    var difficultyEasy : Bool = false
    var isPlayer1Turn : Bool = false
    var numSticksRemaining : Int = 16
    var numSticksSelected : Int = 0
    
    let semaphore = DispatchSemaphore(value: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.sticks = [self.stick0, self.stick1, self.stick2, self.stick3, self.stick4, self.stick5, self.stick6, self.stick7, self.stick8, self.stick9, self.stick10, self.stick11, self.stick12, self.stick13, self.stick14, self.stick15]
    }

    @IBAction func gameplaybuttonpressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            mainmenupage.isHidden = true
            semaphore.signal()
        }
    }
    
    @IBAction func backbuttonpressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            mainmenupage.isHidden = false
            semaphore.signal()
        }
    }
    
    @IBAction func player2menubuttonpressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            isOnePlayerGame = false
            player1label.isHidden = false
            boardview.isHidden = false
            isPlayer1Turn = true
            semaphore.signal()
        }
    }
    
    @IBAction func player1menubuttonpressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            isOnePlayerGame = true
            difficultyselectionview.isHidden = false
            semaphore.signal()
        }
    }
    
    
    @IBAction func easybuttonpressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            difficultyEasy = true
            playfirstorsecondview.isHidden = false
            difficultyselectionview.isHidden = true
            semaphore.signal()
        }
    }
    
    @IBAction func hardbuttonpressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            difficultyEasy = false
            playfirstorsecondview.isHidden = false
            difficultyselectionview.isHidden = true
            semaphore.signal()
        }
    }
    
    @IBAction func firstbuttonpressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            player1label.isHidden = false
            boardview.isHidden = false
            playfirstorsecondview.isHidden = true
            isPlayer1Turn = true
            semaphore.signal()
        }
    }
    
    @IBAction func secondbuttonpressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            isPlayer1Turn = false
            cpulabel.isHidden = false
            boardview.isHidden = false
            playfirstorsecondview.isHidden = true
            delay(interval: 2.0) {
                if self.cpuMakeMove() {
                    self.cpulabel.isHidden = true
                    self.player1label.isHidden = false
                    self.isPlayer1Turn = true
                }
                self.semaphore.signal()
            }
        }
        
    }
    
    func stickiselected (i : Int) {
        if isSelected[i] {
            switch i {
            case 1,4,9:
                if (numSticksSelected == 1 || isSelected[i+1]) {
                    deselectstickr(r: i)
                }
            case 2,5,6,7,10,11,12,13,14:
                if !isSelected[i-1] {
                    deselectstickr(r: i)
                }
            default:
                if numSticksSelected == 1 {
                    deselectstickr(r: i)
                }
            }
        } else {
            switch i {
                case 1,2,4,5,6,7,9,10,11,12,13,14:
                    if (isSelected[i+1] || (isRemoved[i+1] && numSticksSelected == 0)) {
                       selectstickr(r: i)
                    } // end if
                default:
                    if numSticksSelected == 0 {
                       selectstickr(r: i)
                    } // end if
            } // end switch
        } // end else
    }
    
    func selectstickr(r : Int) {
        self.sticks[r].setTitleColor(.red, for: .normal)
        if (isPlayer1Turn || !isOnePlayerGame) {
            arrowbutton.setTitleColor(.black, for: .normal)
        }
        numSticksSelected += 1
        isSelected[r] = true
    }
    
    func deselectstickr(r : Int) {
        self.sticks[r].setTitleColor(.black, for: .normal)
        isSelected[r] = false
        numSticksSelected -= 1
        if numSticksSelected == 0 {
            arrowbutton.setTitleColor(.lightGray, for: .normal)
        } // end if
    }
    
    @IBAction func stick0pressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            stickiselected(i: 0)
            semaphore.signal()
        }
    }
    
    @IBAction func stick1pressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            stickiselected(i: 1)
            semaphore.signal()
        }
    }
    
    @IBAction func stick2pressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            stickiselected(i: 2)
            semaphore.signal()
        }
    }
    
    @IBAction func stick3pressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            stickiselected(i: 3)
            semaphore.signal()
        }
    }
    
    @IBAction func stick4pressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            stickiselected(i: 4)
            semaphore.signal()
        }
    }
    
    @IBAction func stick5pressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            stickiselected(i: 5)
            semaphore.signal()
        }
    }
    
    @IBAction func stick6pressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            stickiselected(i: 6)
            semaphore.signal()
        }
    }
    
    @IBAction func stick7pressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            stickiselected(i: 7)
            semaphore.signal()
        }
    }
    
    @IBAction func stick8pressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            stickiselected(i: 8)
            semaphore.signal()
        }
    }
    
    @IBAction func stick9pressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            stickiselected(i: 9)
            semaphore.signal()
        }
    }
    
    @IBAction func stick10pressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            stickiselected(i: 10)
            semaphore.signal()
        }
    }
    
    @IBAction func stick11pressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            stickiselected(i: 11)
            semaphore.signal()
        }
    }
    
    @IBAction func stick12pressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            stickiselected(i: 12)
            semaphore.signal()
        }
    }
    
    @IBAction func stick13pressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            stickiselected(i: 13)
            semaphore.signal()
        }
    }
    
    @IBAction func stick14pressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            stickiselected(i: 14)
            semaphore.signal()
        }
    }
    
    @IBAction func stick15pressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            stickiselected(i: 15)
            semaphore.signal()
        }
    }
    
    @IBAction func arrowbuttonpressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            if (numSticksSelected == 0) {
                semaphore.signal()
                return
            }
            arrowbutton.setTitleColor(.lightGray, for: .normal)
            clearSelectedSticks()
            if numSticksRemaining == 0 {
                endGame()
                semaphore.signal()
            } else if isOnePlayerGame {
                isPlayer1Turn = false
                player1label.isHidden = true
                cpulabel.isHidden = false
                delay(interval: 2.0) {
                    if self.cpuMakeMove() {
                        if self.numSticksRemaining == 0 {
                            self.endGame()
                        } else {
                            self.cpulabel.isHidden = true
                            self.player1label.isHidden = false
                            self.isPlayer1Turn = true
                        }
                        self.semaphore.signal()
                    }
                }
            } else {
                if isPlayer1Turn {
                    player1label.isHidden = true
                    player2label.isHidden = false
                    isPlayer1Turn = false
                } else {
                    player2label.isHidden = true
                    player1label.isHidden = false
                    isPlayer1Turn = true
                }
                semaphore.signal()
            }
        }
    }
    
    func removexsticksfromrowm(x:Int,m:Int) -> Bool {
        let idx : Int = m * m + numSticksInRow[m]
        for j in 1...x {
            stickiselected(i: idx - j)
        }
        return clearSelectedSticks()
    }
    
    func clearSelectedSticks() -> Bool {
        for i in 0...15 {
            if isSelected[i] {
                sticks[i].isHidden = true
                isSelected[i] = false
                isRemoved[i] = true
                numSticksRemaining -= 1
                numSticksInRow[Int(Double(i).squareRoot())] -= 1
            }
        }
        numSticksSelected = 0
        return true
    }
    
    func endGame() {
        if isOnePlayerGame {
            if isPlayer1Turn {
                cpuwins.isHidden = false
            } else {
                player1wins.isHidden = false
            }
        } else if isPlayer1Turn {
            player2wins.isHidden = false
        } else {
            player1wins.isHidden = false
        }
        gameoverview.isHidden = false
        for i in 0...15 {
            isRemoved[i] = false
            sticks[i].setTitleColor(.black, for: .normal)
            sticks[i].isHidden = false
        }
        for i in 0...3 {
            numSticksInRow[i] = 2 * i + 1
        }
        arrowbutton.setTitleColor(.lightGray, for: .normal)
        cpulabel.isHidden = true
        player2label.isHidden = true
        player1label.isHidden = true
        numSticksRemaining = 16
        isPlayer1Turn = true
    }
    
    @IBAction func newgamebuttonpressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            if isOnePlayerGame {
                playfirstorsecondview.isHidden = false
                boardview.isHidden = true
                gameoverview.isHidden = true
            } else {
                player1label.isHidden = false
                gameoverview.isHidden = true
                isPlayer1Turn = true
            }
            player1wins.isHidden = true
            player2wins.isHidden = true
            cpuwins.isHidden = true
            semaphore.signal()
        }
    }
    
    @IBAction func mainmenubuttonpressed(_ sender: Any) {
        if (semaphore.wait(timeout: .now()) == .success) {
            boardview.isHidden = true
            gameoverview.isHidden = true
            player1wins.isHidden = true
            player2wins.isHidden = true
            cpuwins.isHidden = true
            semaphore.signal()
        }
    }
    
    func cpuMakeMove() -> Bool {
        if difficultyEasy {
            return makeRandomMove()
        } else {
            return makeOptimizedMove()
        }
    }
    
    func makeRandomMove() -> Bool {
        var row : Int = Int.random(in: 0...3)
        while numSticksInRow[row] < 1 {
            row = Int.random(in: 0...3)
        }
        return removexsticksfromrowm(x: Int.random(in: 1...numSticksInRow[row]), m: row)
    }
    
    func makeOptimizedMove() -> Bool {
        switch (192 * numSticksInRow[0] + 48 * numSticksInRow[1] + 8 * numSticksInRow[2] + numSticksInRow[3]) {
            
        case 210,228,290,304,326,339,360: return removexsticksfromrowm(x: 1, m: 0)
        case 66,84,97,104,132,141,145,152,162,180,189,288,297,325,332,336,345,373,380: return removexsticksfromrowm(x: numSticksInRow[1], m: 1)
        case 96,105,133,140,144,153,181,188,289,296,324,333,337,344,372,381: return removexsticksfromrowm(x: numSticksInRow[1] - 1, m: 1)
        case 146,160,182: return removexsticksfromrowm(x: numSticksInRow[1] - 2, m: 1)
        case 17,25,33,41,64,72,80,88,106,130,138,163,179,187,208,216,224,232,257,265,273,281,323,331,370,378: return removexsticksfromrowm(x: numSticksInRow[2], m: 2)
        case 16,24,32,40,65,73,81,89,139,178,186,209,217,225,233,256,264,272,280,322,330,371,379: return removexsticksfromrowm(x: numSticksInRow[2] - 1, m: 2)
        case 26,34,42,83,91,120,128,136,177,185,227,235,274,282,321,329,368,376: return removexsticksfromrowm(x: numSticksInRow[2] - 2, m: 2)
        case 35,43,82,90,129,137,176,184,226,234,275,283,320,328,369,377: return removexsticksfromrowm(x: numSticksInRow[2] - 3, m: 2)
        case 44,142: return removexsticksfromrowm(x: numSticksInRow[2] - 4, m: 2)
        case 10...15,50...55,113,116...119,172...175,194...199,250...255,316...319,356...359: return removexsticksfromrowm(x: numSticksInRow[3], m: 3)
        case 2...7,58...63,164...167,202...207,242...247,308...311,364...367: return removexsticksfromrowm(x: numSticksInRow[3] - 1, m: 3)
        case 19...23,76...79,99...103,156...159,220...223,260...263,300...303,340...343: return removexsticksfromrowm(x: numSticksInRow[3] - 2, m: 3)
        case 28...31,68...71,108...111,148...151,212...215,268...271,292...295,348...351: return removexsticksfromrowm(x: numSticksInRow[3] - 3, m: 3)
        case 37...39,94,95,125...127,238,239,278,279: return removexsticksfromrowm(x: numSticksInRow[3] - 4, m: 3)
        case 46,47,86,87,230,231,286,287: return removexsticksfromrowm(x: numSticksInRow[3] - 5, m: 3)
        case 135: return removexsticksfromrowm(x: numSticksInRow[3] - 6, m: 3)
        case 75,93,155,191,306: return removexsticksfromrowm(x: 1, m: Int.random(in: 1...3))
        case 115: if Int.random(in: 0...2) < 2 { return removexsticksfromrowm(x: 1, m: Int.random(in: 1...2))} else {return removexsticksfromrowm(x: numSticksInRow[3], m: 3)}
        case 122: if Int.random(in: 0...2) < 1 { return removexsticksfromrowm(x: 1, m: 1)} else if Int.random(in: 0...1) < 1 { return removexsticksfromrowm(x: 1, m: 3)} else {return removexsticksfromrowm(x: numSticksInRow[2], m: 2)}
        case 169...171: return removexsticksfromrowm(x: numSticksInRow[3], m: Int.random(in: 1...3))
        case 266,284,346,382: return removexsticksfromrowm(x: 1, m: Int.random(in: 0...2))
        case 259,277,353,375: if Int.random(in: 0...2) < 1 {return removexsticksfromrowm(x: 1, m: 3)} else {return removexsticksfromrowm(x: 1, m: Int.random(in: 0...1))}
        case 219,237,299,313,335: if Int.random(in: 0...2) < 1 {return removexsticksfromrowm(x: 1, m: 0)} else {return removexsticksfromrowm(x: 1, m: Int.random(in: 2...3))}
        case 315: if Int.random(in: 0...2) < 1 {return removexsticksfromrowm(x: 1, m: 1)} else if Int.random(in: 0...1) < 1 {return removexsticksfromrowm(x: 3, m: 3)} else {return removexsticksfromrowm(x: 3, m: 2)}
        case 355: if Int.random(in: 0...2) < 1 {return removexsticksfromrowm(x: 1, m: 2)} else if Int.random(in: 0...1) < 1 {return removexsticksfromrowm(x: 3, m: 3)} else {return removexsticksfromrowm(x: 3, m: 1)}
        case 362: if Int.random(in: 0...2) < 1 {return removexsticksfromrowm(x: 3, m: 1)} else if Int.random(in: 0...1) < 1 {return removexsticksfromrowm(x: 3, m: 2)} else {return removexsticksfromrowm(x: 2, m: 3)}
        default: return makeRandomMove()
        }
    }
    
    func delay(interval: TimeInterval, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            closure()
        }
    }
    
}
