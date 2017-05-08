//
//  File.swift
//  Daze
//
//  Created by David Sirkin on 5/4/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class File: NSObject {
    
    let formatter = DateFormatter()
    
    private func verifyURL() -> URL {
        formatter.dateFormat = "yyyy MMM dd"
        let date = formatter.string(from: Date())
        
        let participant = (UIApplication.shared.delegate as! AppDelegate).participant ?? "Participant"
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
        let url = dir.appendingPathComponent("\(date) \(participant)") as URL
        
        if !FileManager.default.fileExists(atPath: url.path) {
            FileManager.default.createFile(atPath: url.path, contents: nil, attributes: nil)
        }
        return url
    }
    
    private func write(_ data: Data) {
        let url = verifyURL()
        
        if let handle = FileHandle(forWritingAtPath: url.path) {
            defer {
                handle.closeFile()
            }
            handle.seekToEndOfFile()
            handle.write(data)
        } else {
            do {
                try data.write(to: url, options: .atomic)
            } catch {
            }
        }
    }
    
    func save(_ data: String) {
        formatter.dateFormat = "HH:mm:ss:SSS"
        let time = formatter.string(from: Date())
        
        write("\(time), \(data)\n".data(using: String.Encoding.utf8)!)
    }
    
    func read() -> String {
        var data: Data!
        let url = verifyURL()
        
        do {
            let handle = try FileHandle(forReadingFrom: url)
            defer {
                handle.closeFile()
            }
            data = handle.readDataToEndOfFile()
        } catch {
        }
        return String(data: data, encoding: String.Encoding.utf8)!
    }
}

let file = File()
