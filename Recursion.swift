//  Recursion.swift
//
//  Created by Kevin Csiffary
//  Created on 2024-05-03
//  Version 1.0
//  Copyright (c) Kevin Csiffary. All rights reserved.
//
//  Does Recursion stuff.
import Foundation

// This is the main method.
func main() {
    do {
        // Setup scanner on file.
        let fileURL = URL(fileURLWithPath: "input.txt")
        let fileContent = try String(contentsOf: fileURL)
        let lines = fileContent.components(separatedBy: .newlines)

        // Setup output files.
        guard let binOutput = OutputStream(toFileAtPath: "binOutput.txt", append: false) else {
            print("Error creating binOutput file")
            return
        }
        binOutput.open()

        guard let palenOutput = OutputStream(toFileAtPath: "palenOutput.txt", append: false) else {
            print("Error creating palenOutput file")
            return
        }
        palenOutput.open()

        for line in lines {
            // Check if line is valid input.
            if let intLine = Int(line) {
                // Get the number of bits that are needed to contain the number.
                let numBits = Int(log2(Double(intLine)))
                // Call method and write to file.
                let binStr = decToBin(intLine, numBits + 1) + "\n"
                if binOutput.write(binStr, maxLength: binStr.utf8.count) < 0 {
                    print("Error writing to binOutput file")
                }
            } else {
                if binOutput.write("Please input a number!\n", maxLength: 23) < 0 {
                    print("Error writing to binOutput file")
                }
            }

            if let longLine = Int64(line) {
                // Call method and write to file.
                let palenStr = String(isAPalindrome(longLine)) + "\n"
                if palenOutput.write(palenStr, maxLength: palenStr.utf8.count) < 0 {
                    print("Error writing to palenOutput file")
                }
            } else {
                if palenOutput.write("Please input a number!\n", maxLength: 23) < 0 {
                    print("Error writing to palenOutput file")
                }
            }
        }

        // Close all writers.
        binOutput.close()
        palenOutput.close()
    } catch {
        print(error)
    }
}

// Turns a decimal number into binary.
func decToBin(_ num: Int, _ numBits: Int) -> String {
    let magicFour = 4

    // Check if the number has run out.
    if numBits == 0 {
        return ""
    } else {
        // Add an extra space in sets of 4 binary digits.
        let space = numBits % magicFour == 0 ? " " : ""
        // Calculate the value of the current binary digit.
        let power = Int(pow(2.0, Double(numBits - 1)))
        // Check if the number is greater than or equal to the power.
        if num >= power {
            // Return a 1 with the recursive call.
            return space + "1" + decToBin(num - power, numBits - 1)
        } else {
            // Return a 0 with the recursive call.
            return space + "0" + decToBin(num, numBits - 1)
        }
    }
}

// Palindromes.
func isAPalindrome(_ num: Int64) -> Bool {
    let stringNum = String(num)
    // Check if there are two or fewer numbers and if they are equal.
    if stringNum.count <= 2 && stringNum.first == stringNum.last {
        return true
    } else {
        // Check if the first character is the same as the last.
        if stringNum.first == stringNum.last {
            // Remove the first and last element from the string.
            let shortString = String(stringNum.dropFirst().dropLast())
            // Recursive call.
            return isAPalindrome(Int64(shortString)!)
        } else {
            return false
        }
    }
}

// Call the main function
main()
