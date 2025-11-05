//  CharacterView.swift
//  BBQuotes
//
//  Created by Nick Coleman on 11/4/25.
//

import SwiftUI

struct CharacterView: View {
    let character: Char
    let show: String
    
    let vm = ViewModel()
    
    var body: some View {
        GeometryReader { geo in
            ZStack (alignment: .top) {
                Image(show.lowercased().replacingOccurrences(of: " ", with: ""))
                    .resizable()
                    .scaledToFit()
                
                ScrollView {
                    AsyncImage(url: character.images[0]) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .frame(width: geo.size.width/1.2, height: geo.size.width/1.7)
                    .padding(.top, 200)
                    
                    VStack(alignment: .leading) {
                        Text(character.name)
                            .font(.largeTitle)
                        
                        Text("Portrayed by \(character.portrayedBy)")
                            .font(.subheadline)
                        
                        Divider()
                        
                        Text("\(character.name) Character Info")
                            .font(.title2)
                        
                        Text("Born: \(character.birthday)")
                        
                        Divider()
                        
                        Text("Occupations:")
                            .font(.headline)
                        
                        ForEach(character.occupations, id: \.self) { occupation in
                            Text("• \(occupation)")
                                .font(.subheadline)
                        }
                        
                        Divider()
                        
                        Text("Aliases:")
                            .font(.headline)
                        
                        if (character.aliases.count > 0) {
                            ForEach(character.aliases, id: \.self) { alias in
                                Text("• \(alias)")
                                    .font(.subheadline)
                            }
                        } else {
                            Text("None")
                                .font(.subheadline)
                        }
                        
                        Divider()
                        
                        DisclosureGroup("Status (spoiler alert!):") {
                            VStack(alignment: .leading) {
                                if let death = character.death {
                                    Text("Dead")
                                        .font(.subheadline)
                                    AsyncImage(url: death.image) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    Text("How: \(death.details)")
                                        .padding(.bottom, 7)
                                    Text("Last Words: \"\(death.lastWords)\"")
                                        .italic()
                                } else {
                                    Text("Status: Alive")
                                        .font(.subheadline)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .tint(.primary)
                        

                    }
                    .frame(width: geo.size.width/1.25, alignment: .leading)
                    .padding(.top, 125)
                    .padding(.bottom, 50)
                    
                    
                }
                .scrollIndicators(.hidden)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CharacterView(
        character: ViewModel().character,
        show: "Breaking Bad"
    )
}
