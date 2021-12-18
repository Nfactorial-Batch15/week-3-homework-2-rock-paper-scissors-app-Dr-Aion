//
//  ContentView.swift
//  HW8
//
//  Created by Aiganym Moldagulova on 16/12/2021.
//

import SwiftUI

extension Color{
    static func rgb(r: Double, g: Double, b: Double) -> Color {
        return Color(red: r / 255, green: g / 255, blue: b / 255)
    }
    static let myPurple = Color.rgb(r: 103, g: 80, b: 164)
    static let lightPurple = Color.rgb(r: 243, g: 242, b: 248)
    static let orangeStart = Color.rgb(r: 255, g: 204, b: 0)
    static let orangeEnd = Color.rgb(r: 255, g: 92, b: 0)
    static let redStart = Color.rgb(r: 255, g: 105, b: 97)
    static let redEnd = Color.rgb(r: 253, g: 77, b: 77)
    static let greenStart = Color.rgb(r: 181, g: 238, b: 155)
    static let greenEnd = Color.rgb(r: 36, g: 174, b: 67)
}

struct GradientText: View {
    var body: some View {
        Text("Gradient foreground")
            .gradientForeground(colors: [.red, .blue])
            .padding(.horizontal, 20)
            .padding(.vertical)
            .background(Color.green)
            .cornerRadius(10)
            .font(.title)
       }
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing))
            .mask(self)
    }
}

class Game: ObservableObject{
    @Published var score = 3
    @Published var Player1Pick = ""
    @Published var Player2Pick = ""
    @Published var Player2Options = Int.random(in: 1..<4)
    @Published var Player1Score = 0
    @Published var Player2Score = 0
    @Published var r = "🗿"
    @Published var p = "📄"
    @Published var s = "✂️"
}

struct RPSButton: View{
    var emoji: String
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 48)
                .fill(Color.lightPurple)
                .frame(height: 128)
            Text(emoji)
                .font(.system(size: 80))
        }
    }
}

struct RPSChoice: View{
    
    func playersChoice(choice: String) -> String{
        if(choice == "rock"){
            return game.r
        }
        else if(choice == "paper"){
            return game.p
        }
        else{
            return game.s
        }
    }
    
    @EnvironmentObject var game: Game
    
    @State private var rock = true
    @State private var paper = true
    @State private var scissors = true
    
    @State private var rock2 = false
    @State private var paper2 = false
    @State private var scissors2 = false
    
    @State private var changedMind = false
    @State private var opponent = false
    @State private var opponentComputer = false
    @State private var opponentComputerPick = false
    @State private var opponentPerson = false
    @State private var isResult = false
    @State private var isAnimated = false


    @State var seconds = 1
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Binding var text: String
    @Binding var textScore: String
    
    @State var textResult: String = ""
    @State var startGradient: Color = .clear
    @State var endGradient: Color = .clear

    @Binding var choiceMultiPlayer: Bool

    @State private var Player1 = true
    @State private var Player2 = false

    
    var body: some View{
        VStack(spacing: 24){
            if rock{
                RPSButton(emoji: "🗿")
                    .transition(.asymmetric(insertion: .slide, removal: .opacity))
                    .onTapGesture {
                        withAnimation{
                            text = "Your pick"
                            paper = false
                            scissors = false
                            changedMind = true
                            opponent = false
                            if(Player1){
                                game.Player1Pick = "rock"
                            }
                            else{
                                game.Player2Pick = "rock"
                                changedMind = false
                                opponent = false
                                isResult = true
                            }
                        }
                    }
            }
           
            if paper{
                RPSButton(emoji: "📄")
                    .transition(.asymmetric(insertion: .slide, removal: .opacity))
                    .onTapGesture {
                        withAnimation{
                            text = "Your pick"
                            rock = false
                            scissors = false
                            changedMind = true
                            opponent = false
                            if(Player1){
                                game.Player1Pick = "paper"
                            }
                            else{
                                game.Player2Pick = "paper"
                                changedMind = false
                                opponent = false
                                isResult = true
                            }
                        }
                    }
            }
            
            if scissors{
                RPSButton(emoji: "✂️")
                    .transition(.asymmetric(insertion: .slide, removal: .opacity))
                    .onTapGesture {
                        withAnimation{
                            text = "Your pick"
                            rock = false
                            paper = false
                            changedMind = true
                            opponent = false
                            if(Player1){
                                game.Player1Pick = "scissors"
                            }
                            else{
                                game.Player2Pick = "scissors"
                                changedMind = false
                                opponent = false
                                isResult = true
                            }
                        }
                    }
            }
            if changedMind{
                Spacer()
                Text("\(String(seconds))")
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.myPurple)
                        .frame(height: 50)
                    Button {
                        withAnimation{
                            text = "Take your pick"
                            rock = true
                            paper = true
                            scissors = true
                            game.Player1Pick = ""
                            self.seconds = 1
                        }
                    } label: {
                        Text("I changed my mind")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white)
                    }
                }
                .onReceive(timer){ _ in
                    if(seconds < 3){
                        self.seconds = self.seconds + 1
                    }
                    else if(seconds == 3) {
                        rock = false
                        paper = false
                        scissors = false
                        self.seconds = 1
                        opponent = true
                    }
                }
            }
            if opponent{
                if choiceMultiPlayer{
                    Spacer()
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.myPurple)
                            .frame(height: 50)
                        Button {
                            withAnimation{
                                text = "Your pick"
                                rock = true
                                paper = true
                                scissors = true
                                Player1 = false
                                Player2 = true
                                game.Player2Pick = ""
                                changedMind = false
                                textScore = "Player 2 \(String(game.Player1Score)):\(String(game.Player2Score))"
                            }
                        } label: {
                            Text("Ready to continue")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.white)
                        }
                    }
                    .onAppear{
                        withAnimation{
                            text = "Pass the phone to your opponent"
                        }
                        changedMind = false
                        textScore = ""
                    }
                }
                else{
                    VStack{
                        RPSButton(emoji: "⏳")
                            .onAppear{
                                withAnimation{
                                    text = "Your opponent is thinking"
                                }
                                changedMind = false
                                if(game.Player2Options == 1){
                                    game.Player2Pick = "rock"
                                }
                                else if(game.Player2Options == 2){
                                    game.Player2Pick = "rock"
                                }
                                else if(game.Player2Options == 3){
                                    game.Player2Pick = "scissors"
                                }
                            }
                        Spacer()
                        Text("\(String(seconds))")
                    }
                    .onReceive(timer){ _ in
                        if(seconds < 3){
                            self.seconds = self.seconds + 1
                        }
                        else if(seconds == 3) {
                            opponentComputerPick = true
                            self.seconds = 1
                        }
                    }
                }
                
            }
          
            if opponentComputerPick{
                VStack{
                    RPSButton(emoji: playersChoice(choice: game.Player2Pick))
                        .onAppear{
                            withAnimation{
                                text = "Your opponent's pick"
                            }
                        }
                    Spacer()
                }
                .onAppear{
                    opponent = false
                }
                .onReceive(timer){ _ in
                    if(seconds < 3){
                        self.seconds = self.seconds + 1
                    }
                    else if(seconds == 3) {
                        isResult = true
                        self.seconds = 1
                    }
                }
            }
            if isResult{
                VStack{
                    Text(textResult)
                        .gradientForeground(colors: [startGradient, endGradient])
                        .font(.system(size: 54, weight: .regular))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 12)
                    Text("Score \(String(game.Player1Score)):\(String(game.Player2Score))")
                        .foregroundColor(Color.myPurple)
                        .font(.system(size: 17, weight: .bold))
                        .multilineTextAlignment(.center)
                    ZStack{
                        HStack{
                            ZStack{
                                RoundedRectangle(cornerRadius: 48)
                                    .fill(Color.lightPurple)
                                    .frame(width: 198, height: 128)
                                Text(playersChoice(choice: game.Player1Pick))
                                    .font(.system(size: 80))
                            }.padding(.top, 134)
                            .transition(.slide)
                            Spacer()
                        }

                        HStack{
                            Spacer()
                            ZStack{
                                RoundedRectangle(cornerRadius: 48)
                                    .fill(Color.lightPurple)
                                    .frame(width: 198, height: 128)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 48)
                                            .stroke(style: StrokeStyle(lineWidth:10))
                                            .fill(Color.white)
                                    )
                                Text(playersChoice(choice: game.Player2Pick))
                                    .font(.system(size: 80))
                            }.padding(.top, 214)
                                .transition(.slide)
                        }
                    }
                    Spacer()
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.myPurple)
                            .frame(height: 50)
                        Button {
                            withAnimation{
                                text = "Take your pick"
                                rock = true
                                paper = true
                                scissors = true
                                game.Player1Pick = ""
                                game.Player2Pick = ""
                                isResult = false
                                if choiceMultiPlayer{
                                    textScore = "Player 1 \(String(game.Player1Score)):\(String(game.Player2Score))"
                                }else{
                                    textScore = "Score \(String(game.Player1Score)):\(String(game.Player2Score))"
                                }
                            }
                        } label: {
                            Text("Another round")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.white)
                        }
                    }
                }
                .onAppear{
                    switch game.Player1Pick {
                        case "rock":
                            if( game.Player2Pick == "scissors"){
                                textResult = "Win!"
                                startGradient = .orangeStart
                                endGradient = .orangeEnd
                                game.Player1Score = game.Player1Score + 1
                            } else if( game.Player2Pick == "paper"){
                                textResult = "Lose"
                                startGradient = .redStart
                                endGradient = .redEnd
                                game.Player2Score = game.Player2Score + 1
                            } else{
                                textResult = "Tie!"
                                startGradient = .greenStart
                                endGradient = .greenEnd
                            }
                        case "paper":
                            if( game.Player2Pick == "rock"){
                                textResult = "Win!"
                                startGradient = .orangeStart
                                endGradient = .orangeEnd
                                game.Player1Score = game.Player1Score + 1
                            } else if(game.Player2Pick == "scissors"){
                                textResult = "Lose"
                                startGradient = .redStart
                                endGradient = .redEnd
                                game.Player2Score = game.Player2Score + 1
                            } else{
                                textResult = "Tie!"
                                startGradient = .greenStart
                                endGradient = .greenEnd
                            }
                        case "scissors":
                            if( game.Player2Pick == "paper"){
                                textResult = "Win!"
                                startGradient = .orangeStart
                                endGradient = .orangeEnd
                                game.Player1Score = game.Player1Score + 1
                            } else if(game.Player2Pick == "rock"){
                                textResult = "Lose"
                                startGradient = .redStart
                                endGradient = .redEnd
                                game.Player2Score = game.Player2Score + 1
                            } else{
                                textResult = "Tie!"
                                startGradient = .greenStart
                                endGradient = .greenEnd
                            }
                        default:
                            break
                    }
                    withAnimation {
                        isAnimated.toggle()
                    }
                    rock = false
                    paper = false
                    scissors = false

                    text = ""
                    textScore = ""
                    opponent = false
                    opponentComputerPick = false
                    Player1 = true
                    Player2 = false
                }
            }
        }
    }
}

struct SecondView: View{
    @EnvironmentObject var game: Game
    
    @State private var SecondViewText = "Take your pick"
    @State private var SecondViewScoreSingleMode = "Score 0:0"
    @State private var SecondViewScoreMultiMode = "PLayer 1 Score 0:0"
    
    @Binding var singlePlayerMode: Bool
    @Binding var multiPlayerMode: Bool

    var body: some View{
        VStack (spacing: 24){
            Text(SecondViewText)
                .font(.system(size: 54, weight: .regular))
                .multilineTextAlignment(.center)
            
            
            if(singlePlayerMode){
                Text(SecondViewScoreSingleMode)
                    .foregroundColor(Color.myPurple)
                    .font(.system(size: 17, weight: .bold))
                    .multilineTextAlignment(.center)
                RPSChoice(text: $SecondViewText, textScore: $SecondViewScoreSingleMode, choiceMultiPlayer: $multiPlayerMode)
            }else{
                Text(SecondViewScoreMultiMode)
                    .foregroundColor(Color.myPurple)
                    .font(.system(size: 17, weight: .regular))
                    .multilineTextAlignment(.center)
                RPSChoice(text: $SecondViewText, textScore: $SecondViewScoreMultiMode, choiceMultiPlayer: $multiPlayerMode)
            }
        }
        .padding(.horizontal, 16)
        .navigationTitle("Round #1")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContentView: View {
    @ObservedObject var game = Game()

   @State private var showSecondView = false
   @State var singlePlayerMode = false
   @State var multiPlayerMode = false

    
    var body: some View {
            NavigationView{
                ZStack{
                    Image("BackgroundImage")
                        .ignoresSafeArea(.all)
                VStack{
                    Text("Welcome to the game!")
                        .font(.system(size: 54, weight: .regular))
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 450)
                    NavigationLink(destination: SecondView(singlePlayerMode: $singlePlayerMode, multiPlayerMode: $multiPlayerMode), isActive: $showSecondView){
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.myPurple)
                                .frame(height: 50)
                            Button {
                                self.showSecondView = true
                                self.singlePlayerMode = true
                                self.multiPlayerMode = false
                            } label: {
                                Text("Single player")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    NavigationLink(destination: SecondView(singlePlayerMode: $singlePlayerMode, multiPlayerMode: $multiPlayerMode), isActive: $showSecondView){
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.myPurple)
                                .frame(height: 50)
                            Button {
                                self.showSecondView = true
                                self.singlePlayerMode = false
                                self.multiPlayerMode = true
                            } label: {
                                Text("Multi player")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .onAppear{
                        game.Player1Score = 0
                        game.Player2Score = 0
                    }
            }
        }
        .environmentObject(game)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
