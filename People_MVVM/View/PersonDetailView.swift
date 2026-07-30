//
//  PersonDetailView.swift
//  People_MVVM
//
//  Created by Kim Le on 3/24/26.
//

import SwiftUI

struct PersonDetailView: View {
    let person: Person

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: person.avatar ?? "")) { img in
                    img.resizable().scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(maxHeight: 300)
                .cornerRadius(12)

                VStack(alignment: .leading, spacing: 10) {
                    Text("\(person.firstName) \(person.lastName)").font(.largeTitle).bold()
                    Text(person.jobTitle ?? "No Title Provided").font(.title3)
                    Text("Email: \(person.email)").font(.body)
                    Text("Favorite Color: \(person.favouriteColor ?? "N/A")")
                        .foregroundColor(.secondary)
        
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    PersonDetailView()
//}
