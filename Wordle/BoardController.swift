import Foundation
import UIKit

class BoardController: NSObject,
                       UICollectionViewDataSource,
                       UICollectionViewDelegate,
                       UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    let numItemsPerRow = 5
    let numRows = 6
    let collectionView: UICollectionView
    let goalWord: [String]
    
    var numGuesses = 0
    var currRow: Int {
        return numGuesses / numItemsPerRow
    }
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.goalWord = WordGenerator.generateRandomWord()!.map { String($0) }
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Public Methods
    func enter(_ string: String) {
        guard numGuesses < numItemsPerRow * numRows else { return }
        
        // Get the current cell where the letter will be entered
        let cell = collectionView.cellForItem(at: IndexPath(item: numGuesses, section: 0)) as! LetterCell
        
        // Set the letter in the cell
        cell.set(letter: string)
        
        // Animate the cell
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: [.autoreverse],
                       animations: {
            // Scale the cell by 1.05 (zoom effect)
            cell.transform = cell.transform.scaledBy(x: 1.05, y: 1.05)
        }, completion: { finished in
            // Reset the transform to its original state after the animation completes
            cell.transform = CGAffineTransform.identity
        })
        
        // Check if it's the final guess in the row
        if isFinalGuessInRow() {
            markLettersInRow()
        }
        
        numGuesses += 1
    }
    
    func deleteLastCharacter() {
        // Ensure there is a letter to delete and we're not at the beginning of the row
        guard numGuesses > 0 && numGuesses % numItemsPerRow != 0 else { return }
        
        // Get the current cell to delete the letter
        let cell = collectionView.cellForItem(at: IndexPath(item: numGuesses - 1, section: 0)) as! LetterCell
        
        // Decrease the number of guesses
        numGuesses -= 1
        
        // Clear the letter from the cell
        cell.clearLetter()
        
        // Set the style back to initial
        cell.set(style: .initial)
    }
    
    // MARK: - Helper Methods
    
    private func isFinalGuessInRow() -> Bool {
        return numGuesses % numItemsPerRow == 0
    }
    
    private func markLettersInRow() {
        // Implement the logic to check the letters in the row
        // This could involve comparing the letters in the current row to the goal word
        // For example:
        
        for index in 0..<numItemsPerRow {
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section: currRow)) as! LetterCell
            let letter = cell.letterLabel.text ?? ""
            
            // Check if the letter matches the goal word and mark accordingly
            if letter == goalWord[index] {
                cell.set(style: .correctLetterAndPosition)
            } else if goalWord.contains(letter) {
                cell.set(style: .correctLetterOnly)
            } else {
                cell.set(style: .incorrect)
            }
        }
    }
}
