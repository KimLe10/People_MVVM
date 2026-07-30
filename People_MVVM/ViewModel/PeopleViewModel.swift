//
//  PeopleViewModel.swift
//  People_MVVM
//
//  Created by Kim Le on 3/24/26.
//

import Combine
import Foundation

enum ViewState {
    case loading
    case loaded([Person])
    case error(String)
}


final class PeopleViewModel: ObservableObject {
    @Published var state: ViewState = .loading
    @Published var searchText: String = ""
    // Store the full list to avoid refetching from API
    private var originalPeopleList:[Person] = []
    private var cancellables = Set<AnyCancellable>()
    private let service: PeopleService

    init(service: PeopleService = NetworkManager()) {
        self.service = service
        createSearchTextBinding()
    }
    deinit {
            // Force all active timers and network calls to stop immediately
            cancellables.forEach { $0.cancel() }
            cancellables.removeAll()
        }
    
    func createSearchTextBinding(){
        $searchText
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchWord in
                self?.searchListWithWord(searchWord:searchWord)
            }.store(in: &cancellables)
    }
    
    private func searchListWithWord(searchWord:String){
        guard !originalPeopleList.isEmpty else { return }
        
        if searchWord.isEmpty{
            self.state = .loaded(originalPeopleList)
        }else{
            let filteredList = originalPeopleList.filter{
                $0.firstName.lowercased().contains(searchWord.lowercased()) ||
                $0.lastName.lowercased().contains(searchWord.lowercased())
            }
            self.state = .loaded(filteredList)
        }
    }
    
    @MainActor
    func getPeople() async {
        state = .loading
        
        // Waiting for the publisher's first value.
        do {
            let people = try await service.fetchPeople()
                .values // This converts the Combine publisher to an AsyncSequence
                .first(where: { _ in true }) // We take the first result that comes back
            
            guard let people = people else {
                self.state = .error("No data found")
                return
            }

            // Update the state only after we have the data
            self.originalPeopleList = people
            self.state = .loaded(people)
            
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }
}
