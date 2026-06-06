// JobListViewModel.swift
// ViewModel for managing job listings and search
import Foundation
import Combine

@MainActor
final class JobListViewModel: ObservableObject {
    @Published private(set) var jobs: [Job] = []
    @Published var searchText: String = ""
    @Published private(set) var filteredJobs: [Job] = []
    @Published private(set) var state: State = .idle
    @Published var errorMessage: String?

    enum State {
        case idle, loading, loaded, empty, error
    }

    private let service: JobServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(service: JobServiceProtocol) {
        self.service = service
        setupSearch()
    }

    func loadJobs() async {
        state = .loading
        do {
            let jobs = try await service.fetchJobs()
            self.jobs = jobs
            self.state = jobs.isEmpty ? .empty : .loaded
            self.filteredJobs = jobs
        } catch {
            self.state = .error
            self.errorMessage = error.localizedDescription
        }
    }

    private func setupSearch() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self = self else { return }
                self.filterJobs()
            }
            .store(in: &cancellables)
    }

    private func filterJobs() {
        guard !searchText.isEmpty else {
            filteredJobs = jobs
            return
        }
        let query = searchText.lowercased()
        filteredJobs = jobs.filter {
            $0.title.lowercased().contains(query) || $0.company.lowercased().contains(query)
        }
        state = filteredJobs.isEmpty ? .empty : .loaded
    }
}
