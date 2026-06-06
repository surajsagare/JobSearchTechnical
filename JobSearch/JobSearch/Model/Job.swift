// Job.swift
// Simple data model for a job listing
import Foundation

struct Job: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let company: String
    let location: String
    let salaryRange: String
    let description: String
}
