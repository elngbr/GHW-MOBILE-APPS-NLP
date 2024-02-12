//
//  ContentView.swift
//  Cheerify
//
//  Created by Kari on 1/5/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var affirmation: String = "Get started by pressing the refresh button..."
    @State var favorite = "heart"
    var body: some View {
        NavigationStack() {
            ZStack{
                Color(red: 242/255, green: 237/255, blue: 228/255)
                    .ignoresSafeArea()
                VStack {
                    HStack{
                        NavigationLink {
                            MenuView()
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .frame(width: 45, height: 45)
                                .background(Color(red: 196/255, green: 197/255, blue: 202/255))
                                .clipShape(Circle())
                                .font(.title)
                                .foregroundColor(Color.white)
                        }
                        .padding(.leading, 10)
                        Spacer()
                        VStack {
                            Text("Cheerify")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 63/255, green: 65/255, blue: 78/255))
                            Text("daily affirmation companion")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 63/255, green: 65/255, blue: 78/255))
                        }
                        Spacer()
                        NavigationLink {
                            AddView()
                        } label: {
                            Image(systemName: "plus")
                                .frame(width: 45, height: 45)
                                .background(Color(red: 196/255, green: 197/255, blue: 202/255))
                                .clipShape(Circle())
                                .font(.title)
                                .foregroundColor(Color.white)
                        }
                        .padding(.trailing, 10)
                        
                        
                    }
                    Spacer()
                    Text(affirmation)
                        .onAppear {
                            Task {
                                let (data, _) = try await URLSession.shared.data(from: URL(string: "https://www.affirmations.dev/")!)
                                let decodedResponse = try? JSONDecoder().decode(Affirmation.self, from: data)
                                affirmation = decodedResponse?.affirmation ?? "failed"
                            }
                        }
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 63/255, green: 65/255, blue: 78/255))
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                    HStack{
                        Button {
                            Task {
                                let (data, _) = try await URLSession.shared.data(from: URL(string: "https://www.affirmations.dev/")!)
                                let decodedResponse = try? JSONDecoder().decode(Affirmation.self, from: data)
                                affirmation = decodedResponse?.affirmation ?? "failed"
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .frame(width: 45, height: 45)
                                .background(Color(red: 196/255, green: 197/255, blue: 202/255))
                                .clipShape(Circle())
                                .font(.title)
                                .foregroundColor(Color.white)
                        }
                        .padding(.leading, 10)
                        Spacer()
                        Button {
                                let favAffirmation = Entity(context: managedObjectContext)
                                favAffirmation.text = affirmation
                                favAffirmation.isFavorite = true
                                favAffirmation.isCustom = false
                                PersistenceController.shared.save()
                                favorite = "heart.fill"
                        } label: {
                            Image(systemName: favorite)
                                .frame(width: 45, height: 45)
                                .background(Color(red: 196/255, green: 197/255, blue: 202/255))
                                .clipShape(Circle())
                                .font(.title)
                                .foregroundColor(Color.white)
                        }
                        .padding(.trailing, 10)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)

    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
