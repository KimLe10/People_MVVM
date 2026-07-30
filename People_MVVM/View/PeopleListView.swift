//
//  PeopleListView.swift
//  People_MVVM
//
//  Created by Kim Le on 3/24/26.
//

import SwiftUI

struct PeopleListView: View {
    @StateObject private var viewModel = PeopleViewModel()

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView("Loading People...")
                    
                case .error(let message):
                    VStack {
                        Text("Uh oh!").font(.headline)
                        Text(message).foregroundColor(.red)
                        // Use 'Task' to call async functions from a synchronous button action
                        Button("Retry") {
                            Task { await viewModel.getPeople() }
                        }
                    }
                    
                case .loaded(let people):
                    List(people) { person in
                        NavigationLink(destination: PersonDetailView(person: person)) {
                            PersonCell(person: person)
                        }
                    }
                }
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("People")
            .task { await viewModel.getPeople() }
            .refreshable {  await viewModel.getPeople() }
        }
    }
}
//
//#Preview {
//    PeopleListView()
//}
