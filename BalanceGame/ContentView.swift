//
//  ContentView.swift
//  BalanceGame
//
//  Created by Gustavo da Silva Braghin on 22/06/22.
//


import SwiftUI
import CoreMotion

extension UIColor {
    static let backgroundOn: UIColor = UIColor(named: "background_on")!
    static let backgroundOff: UIColor = UIColor(named: "background_off")!
    static let backgroundOnAlign: UIColor = UIColor(named: "background_on_align")!
    static let backgroundOffAlign: UIColor = UIColor(named: "background_off_align")!
}

struct AccelerometerView: View {
    
    private let motionManager = CMMotionManager()
    private  let queue = OperationQueue()
    
    @EnvironmentObject var appState: AppState
    
    @State private var verticalInclination = Double.zero
    @State private var horizontalInclination = Double.zero
    @State private var isAligned = false
    
    private var alignHoleAsset: String {
        appState.isOn ? "on_align_hole_2" : "off_align_hole_2"
    }
    
    private var notAlignHoleAsset: String {
        appState.isOn ? "on_align_hole_1" : "off_align_hole_1"
    }
    
    private var onAlignBallAsset: String {
        isAligned ? "on_align_ball_2" : "on_align_ball_1"
    }
    
    private var backgroundColorAlign: UIColor {
        appState.isOn ? .backgroundOnAlign : .backgroundOffAlign
    }
    
    private var backgroundColor: UIColor {
        appState.isOn ? .backgroundOn : .backgroundOff
    }
    
    fileprivate enum GameValues { }
    
    
    var body: some View {
        
        VStack{
            ZStack {
                Color(isAligned ? backgroundColorAlign : backgroundColor)
                Image(isAligned ? alignHoleAsset : notAlignHoleAsset)
                Image(appState.isOn ? onAlignBallAsset : "off_align_ball")
                    .offset(x: horizontalInclination * GameValues.multiplierFactor,
                            y: verticalInclination * GameValues.multiplierFactor)
            }
            
        }
        .onAppear {
            self.motionManager.startDeviceMotionUpdates(to: self.queue) { (data: CMDeviceMotion?, error: Error?) in
                guard let data = data else { return }
                let attitude: CMAttitude = data.attitude
                
                if (GameValues.verticalRange.contains(Double(attitude.pitch)) && GameValues.horizontalRange.contains(Double(attitude.roll)))  {
                    DispatchQueue.main.async {
                        withAnimation(.easeIn(duration: 0.3)) {
                            self.isAligned = true
                        }
                    }
                    print("Alinhado")
                } else {
                    withAnimation(.easeOut(duration: 0.3)) {
                        self.isAligned = false
                    }

                    print("Pitch: \(Double(attitude.pitch))")
                    print("Roll: \(Double(attitude.roll))")
                }
                
                DispatchQueue.main.async {
                    self.verticalInclination = attitude.pitch
                    self.horizontalInclination = attitude.roll
                }
            }
        }
    }
}

extension AccelerometerView.GameValues {
    static let multiplierFactor: Double = 250
    static let verticalRange = -0.040...0.040
    static let horizontalRange = (-0.040)...0.040
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AccelerometerView()
            .environmentObject(AppState(isOn: false))
    }
}
