//
//  ContentView.swift
//  BalanceGame
//
//  Created by Gustavo da Silva Braghin on 22/06/22.
//

import SwiftUI
import CoreMotion

struct AccelerometerView: View {
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    
    @State private var verticalInclination = Double.zero
    @State private var horizontalInclination = Double.zero
    
    var body: some View {
        
        VStack{
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.red)
                    .offset(x: horizontalInclination*50, y: verticalInclination*50)
            
        }
        .onAppear {
            print("ON APPEAR")
            self.motionManager.startDeviceMotionUpdates(to: self.queue) { (data: CMDeviceMotion?, error: Error?) in
                guard let data = data else {
                    print("Error: \(error!)")
                    return
                }
                let attitude: CMAttitude = data.attitude
                
                print("pitch: \(attitude.pitch)")
                print("yaw: \(attitude.yaw)")
                print("roll: \(attitude.roll)")
                
                DispatchQueue.main.async {
                    self.verticalInclination = attitude.pitch
                    self.horizontalInclination = attitude.roll
                }
            }
        }//.onappear
    }//view
}//struct

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AccelerometerView()
    }
}
