// JobService.swift
// Service to fetch jobs from mock JSON
import Foundation

protocol JobServiceProtocol {
    func fetchJobs() async throws -> [Job]
}

final class JobService: JobServiceProtocol {
    func fetchJobs() async throws -> [Job] {
        // Load MockJobs.json from the app bundle
        guard let url = Bundle.main.url(forResource: "MockJobs", withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }
        let data = try Data(contentsOf: url)
        let jobs = try JSONDecoder().decode([Job].self, from: data)
        return jobs
    }
}
