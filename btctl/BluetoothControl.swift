//
//  BluetoothControl.swift
//  btctl
//
//  Created by Martin Ivančo on 25/06/2022.
//

import ArgumentParser
import Foundation

struct BluetoothControl: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "btctl",
        abstract: "Bluetooth control utility",
        subcommands: [Connected.self, Paired.self, Connect.self])
    
    struct Connected: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Get list of connected devices")

        func run() {
            guard let devices = BluetoothFramework.connectedDevices else {
                return print("Error: Couldn't fetch connected devices!")
            }

            for d in devices { print("\(d.address)\t\(d.name)") }
        }
    }
    
    struct Paired: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Get list of paired devices")

        func run() {
            guard let devices = BluetoothFramework.pairedDevices else {
                return print("Error: Couldn't fetch paired devices!")
            }

            for d in devices { print("\(d.address)\t\(d.name)") }
        }
    }
    
    struct Connect: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Connect to a bluetooth device")

        @Argument(help: "The address of the device to connect")
        var address: String
        
        @Option(name: .shortAndLong, help: "Optional timeout for the call in seconds")
        var timeout: TimeInterval?

        func run() {
            if BluetoothFramework.connect(address: address, timeout: timeout) {
                print("Successfully connected \(address).")
            } else {
                print("Error: Couldn't connect \(address)!")
            }
        }
    }
}
