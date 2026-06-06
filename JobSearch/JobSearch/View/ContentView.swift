//
//  ContentView.swift
//  JobSearch
//
//  Created by Suraj Vilas Sagare on 06/06/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = JobListViewModel(service: JobService())
    @State private var selectedJob: Job?

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search by title or company", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding([.top, .horizontal])

                content
                    .animation(.default, value: viewModel.state)
            }
            .navigationTitle("Jobs")
            .task {
                await viewModel.loadJobs()
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading jobs...")
                .padding()
        case .error:
            Text(viewModel.errorMessage ?? "Failed to load jobs.")
                .foregroundColor(.red)
                .padding()
        case .empty:
            Text("No jobs found.")
                .foregroundColor(.gray)
                .padding()
        default:
            List(viewModel.filteredJobs) { job in
                Button {
                    selectedJob = job
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(job.title)
                            .font(.headline)
                        Text(job.company)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack {
                            Text(job.location)
                                .font(.caption)
                            Spacer()
                            Text(job.salaryRange)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .sheet(item: $selectedJob) { job in
                    JobDetailView(job: job)
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    ContentView()
}
