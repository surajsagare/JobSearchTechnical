// JobListViewModelTests.swift
// Unit tests for JobListViewModel and JobService
import XCTest
//import Testing

@testable import JobSearch

final class MockJobService: JobServiceProtocol {
    var jobs: [Job] = []
    var error: Error?
    func fetchJobs() async throws -> [Job] {
        if let error = error { throw error }
        return jobs
    }
}

final class JobListViewModelTests: XCTestCase {

    @MainActor
    func test_loadJobs_success() async {
        let jobs = [
            Job(id: UUID(), title: "iOS Dev", company: "Apple", location: "Cupertino", salaryRange: "$100k-$150k", description: "Swift stuff")
        ]
        let service = MockJobService()
        service.jobs = jobs
        let vm = JobListViewModel(service: service)
        await vm.loadJobs()
        XCTAssertEqual(vm.jobs, jobs)
        XCTAssertEqual(vm.state, .loaded)
    }

    @MainActor
    func test_loadJobs_empty() async {
        let service = MockJobService()
        service.jobs = []
        let vm = JobListViewModel(service: service)
        await vm.loadJobs()
        XCTAssertEqual(vm.jobs, [])
        XCTAssertEqual(vm.state, .empty)
    }

    @MainActor
    func test_loadJobs_error() async {
        let service = MockJobService()
        service.error = URLError(.badServerResponse)
        let vm = JobListViewModel(service: service)
        await vm.loadJobs()
        XCTAssertEqual(vm.state, .error)
        XCTAssertNotNil(vm.errorMessage)
    }
    
    @MainActor
    func test_search_filter_by_title() async {
        let job1 = Job(id: UUID(), title: "iOS Engineer", company: "Apple", location: "Cupertino", salaryRange: "$100k-$150k", description: "")
        let job2 = Job(id: UUID(), title: "Android Dev", company: "Google", location: "CA", salaryRange: "$90k-$140k", description: "")
        let jobs = [job1, job2]
        let service = MockJobService()
        service.jobs = jobs
        let vm = JobListViewModel(service: service)
        await vm.loadJobs()
        vm.searchText = "ios"
        // Wait for debounce
        try? await Task.sleep(nanoseconds: 400_000_000)
        XCTAssertEqual(vm.filteredJobs, [job1])
    }

    @MainActor
    func test_search_filter_by_company() async {
        let job1 = Job(id: UUID(), title: "iOS Engineer", company: "Apple", location: "Cupertino", salaryRange: "$100k-$150k", description: "")
        let job2 = Job(id: UUID(), title: "Android Dev", company: "Google", location: "CA", salaryRange: "$90k-$140k", description: "")
        let jobs = [job1, job2]
        let service = MockJobService()
        service.jobs = jobs
        let vm = JobListViewModel(service: service)
        await vm.loadJobs()
        vm.searchText = "goog"
        // Wait for debounce
        try? await Task.sleep(nanoseconds: 400_000_000)
        XCTAssertEqual(vm.filteredJobs, [job2])
    }
}

final class JobDetailViewTests: XCTestCase {

    func test_jobDetailView_idMatchesJobId() {
        let jobId = UUID()

        let job = Job(
            id: jobId,
            title: "iOS Developer",
            company: "Apple",
            location: "Cupertino",
            salaryRange: "$100k-$150k",
            description: "Swift Development"
        )

        let view = JobDetailView(job: job)

        XCTAssertEqual(view.id, jobId)
    }
}
