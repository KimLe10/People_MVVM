//
//  PersonCell.swift
//  People_MVVM
//
//  Created by Kim Le on 3/24/26.
//

import SwiftUI

struct PersonCell: View {
    let person: Person

    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: person.avatar ?? "")) { img in
                img.resizable().scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())

            VStack(alignment: .leading) {
                Text("\(person.firstName) \(person.lastName)")
                    .font(.headline)
                    .lineLimit(1)
                Text(person.jobTitle ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
    }
}
