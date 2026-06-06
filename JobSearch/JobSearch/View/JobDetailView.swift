// JobDetailView.swift
// Displays details for a selected job
import SwiftUI

struct JobDetailView: View, Identifiable {
    let job: Job
    var id: UUID { job.id }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(job.title)
                    .font(.largeTitle)
                    .bold()
                Text(job.company)
                    .font(.title2)
                    .foregroundColor(.secondary)
                HStack {
                    Text(job.location)
                    Spacer()
                    Text(job.salaryRange)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                Divider()

                Text("Description")
                    .font(.headline)
                Text(job.description)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
        }
        .navigationTitle("Job Details")
    }
}

#Preview {
    JobDetailView(job: Job(
        id: UUID(),
        title: "iOS Developer",
        company: "Tech Solutions",
        location: "San Francisco, CA",
        salaryRange: "$120,000 - $140,000",
        description: "Join our team to create innovative iOS apps in a collaborative environment."
    ))
}
