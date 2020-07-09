//
//  ViewController.swift
//  Match_Game
//
//  Created by Thien Tung on 7/9/20.
//  Copyright © 2020 Thien Tung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    
    var cardArray = [Card] ()

    var firstFlippedCardIndex: IndexPath?
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer: Timer?
    var miliseconds: Float = 30 * 1000 //10s
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Call the getCard method
        cardArray = model.getCard()
        
        setupTimer()
        
    }
    
    // phuong thuc nay duoc goi khi che do xem duoc hien thi cho nguoi dung
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.playSound(effect: .shuffle)
    }
    
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    @objc func timerElapsed () {
        
        miliseconds -= 1
        
        // Chuyen doi sang giay
        let seconds = String(format: "%.2f", miliseconds/1000)
        
        // Set label
        timerLabel.text = "Thời gian còn lại: \(seconds)"
        
        if miliseconds <= 0 {
            timer?.invalidate()
            timerLabel.textColor = .red
            
            // Kiem tra xem con unmatched card khong
            checkGameEnded()
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Lấy một CardCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // lấy thẻ collectionView đang hiển thị
        let card = cardArray[indexPath.row]
        
        // Đặt thẻ đó cho cell
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Kiem tra timer
        if miliseconds <= 0 {
            return
        }
        
        // Lấy cell mà người dùng chọn
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // Lấy thẻ mà người dùng chọn
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false {
            
            // Quay thẻ
            cell.flip()
            
            // Play the flip sound
            SoundManager.playSound(effect: .flip)
            
            // Set thuộc tính isFlipped
            card.isFlipped = true
            
            // Xác định xem đó là thẻ thứ nhất hay thẻ thứ hai được lật
            if firstFlippedCardIndex == nil {
                
                // Thẻ thứ nhất mở ra
                firstFlippedCardIndex = indexPath
            } else {
                
                // Thẻ thứ hai mở ra
                
                // TODO: Thực hiện match
                checkForMatches(indexPath)
            }
        
        }
        
    } // Ending Didselec Item
    
    // MARK: - Game Logic
    
    func checkForMatches(_ secondFlippedCardIndex: IndexPath) {
        
        // Lấy cell của thẻ đã được hiện ra
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        
        // Lay tam the duoc duoc hien ra
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
    
        // So sanh 2 tam the
        if cardOne.imageName == cardTwo.imageName {
            
            // 2 the phu hop
            
            // Play sound
            SoundManager.playSound(effect: .match)
            
            // Dat trang thai cua the
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // Xoa the khoi danh sach
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Kiem tra xem con the nao chua match khong
            checkGameEnded()
            
        }
        
        else {
            
            // Khong phu hop
            
            // Play sound
            SoundManager.playSound(effect: .nomatch)
            
            // Dat trang thai cua the
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // An 2 the lai
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
            
        }
        
        // CollectionView reload cell của thẻ đầu tiên nếu nó nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        // Reset the dau tien duoc lat
        firstFlippedCardIndex = nil
        
    }
    
    func checkGameEnded() {
        // Kiem tra con the nao unmatched khong
        var isWon = true
        
        for card in cardArray {
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        // Thong bao
        var title = ""
        var message = ""
        
        // Neu khong, dung timer, nguoi choi thang
        if isWon {
            
            if miliseconds > 0 {
                timer?.invalidate()
            }
            
            title = "Chúc mừng !!!"
            message = "Bạn đã thắng"
            
        } else {
            // Neu con, kiem tra timer con lai
            
            if miliseconds > 0 {
                return
            }
            
            title = "Game Over"
            message = "Bạn đã thua"

        }
        
        // Hien thi thang/thua
        showAlert(title, message)
        
    }
    
    func showAlert(_ title: String, _ message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
} // Ending ViewController

