//
//  ContentView.swift
//  Sesi6FirstAPI
//
//  Created by Hidayat Abisena on 28/01/24.
//

import SwiftUI

struct CardView: View {
    @State private var fadeIn: Bool = false
    @State private var moveDownward: Bool = false
    @State private var moveUpward: Bool = false
    @State private var soundNumber = 7
    @State private var showPunchline:Bool = false
    
    let totalSounds = 25
    
    @StateObject private var jokeVM = JokeVM()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text(Constants.setupText)
                        .foregroundStyle(.white)
                        .font(.custom("PermanentMarker-Regular", size: 30))
                    // MARK: - TEXT JOKE
                    Text(jokeVM.joke?.setup ?? Constants.noJoke)
                        .foregroundStyle(.white)
                        .fontWeight(.light)
                        .italic()
                }
                .offset(y: moveDownward ? -218 : -300)
                // MARK: - TEXT PUNCHLINE
                if(showPunchline == true){
                    Text(jokeVM.joke?.punchline ?? Constants.noPunchline)
                        .foregroundStyle(.white)
                        .font(.custom("PermanentMarker-Regular", size: 35))
                        .multilineTextAlignment(.center)
                }
                
                
                // MARK: - BUTTON PUNCHLINE
                
                    Button {
                      performPunchlineAction()
                    } label: {
                        HStack {
                            Text(!showPunchline ? "Punchline".uppercased() : "Refresh !!")
                                .fontWeight(.heavy)
                                .foregroundStyle(.white)
                            
                            Image(systemName: "arrow.right.circle")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                        }
                        .padding(.vertical)
                        .padding(.horizontal, 24)
                            .background( showPunchline ?
                                         LinearGradient(gradient: Gradient(colors: [Color.color07, Color.color08]), startPoint: .leading, endPoint: .trailing) :
                                            LinearGradient(gradient: Gradient(colors: [Color.color02, Color.color04]), startPoint: .leading , endPoint: .trailing)
                            )
                        
                        
                        .clipShape(Capsule())
                        .shadow(color: Color("ColorShadow"), radius: 6, x: 0, y: 3)
                    }
                .offset(y: moveUpward ? 210 : 300)
                .disabled(showPunchline)
                
                
                
                

            }
            // MARK: - REFRESH SETUP
            .toolbar{
                ToolbarItem(placement:.topBarTrailing){
                    Button{
                        Task{
                            await jokeVM.fetchJoke()
                            showPunchline.toggle()
                        }
                    }label: {
                        Image(systemName:"arrow.clockwise")
                            .foregroundStyle(.white)
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.color07,Color.color08]), startPoint: .leading, endPoint: .trailing)
                            )
                            .clipShape(Circle())
                    }
                    
                }
            }
            .task {
                await jokeVM.fetchJoke()
            }
            .frame(width: 335, height: 545)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.color07, Color.color08]), startPoint: .top, endPoint: .bottom)
            )
            .opacity(fadeIn ? 1.0 : 0.0)
            .onAppear() {
              withAnimation(.linear(duration: 1.2)) {
                self.fadeIn.toggle()
              }
                
              withAnimation(.linear(duration: 0.6)) {
                self.moveDownward.toggle()
                self.moveUpward.toggle()
              }
            }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    CardView()
}

// MARK: - EXTENSION
extension CardView{
    func performPunchlineAction() {
        playSound(soundName: "\(soundNumber)")
        soundNumber += 1
        if soundNumber > totalSounds {
            soundNumber = 0
        }
        showPunchline.toggle()
        
    }
}
