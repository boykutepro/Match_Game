//
//  CardModel.swift
//  Match_Game
//
//  Created by Thien Tung on 7/9/20.
//  Copyright © 2020 Thien Tung. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCard() -> [Card] {
        
        // Tao mang luu tru cac so da generated
        var generatedNumberArray = [Int] ()
        
        // Khai báo một mảng để lưu trữ các thẻ được tạo ngẫu nhiên.
        var generatedCardArray = [Card] ()
        
        // Tạo ngẫu nhiên các cặp thẻ.
        while generatedNumberArray.count < 4 {
            
            // Lấy một số ngẫu nhiên
            let randomNumber = arc4random_uniform(13) + 1
            
            // Dam bao chi co 1 cap the duy nhat
            if generatedNumberArray.contains(Int(randomNumber)) == false {
                // In so
                print(randomNumber)
                
                // Store the number into generatedNumberArray
                generatedNumberArray.append(Int(randomNumber))
                
                // Tạo thẻ đầu tiên
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                
                generatedCardArray.append(cardOne)
                
                // Tạo thẻ thứ hai ghép với thẻ một.
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                generatedCardArray.append(cardTwo)
            }
            
            
            
            
            // OPTIONAL: Chỉ được có những cặp thẻ duy nhất
            
            
        }
        
        // TODO: Ngẫu nhiên các phần tử của mảng.
        
        for i in 0..<generatedCardArray.count {
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardArray.count)))
            
            // Swap two card
            let temporaryStorage = generatedCardArray[i]
            generatedCardArray[i] = generatedCardArray[randomNumber]
            generatedCardArray[randomNumber] = temporaryStorage
        }
        
        
        // Trả về mảng.
        return generatedCardArray
    }
}
