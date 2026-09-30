import SwiftUI

struct ContentView: View {
    // Initial sample student list with 100-point scale
    @State private var students: [Student] = [
        Student(id: "S001", name: "An", gpa: 85.0),
        Student(id: "S002", name: "Binh", gpa: 78.0),
        Student(id: "S003", name: "Chi", gpa: 92.5),
        Student(id: "S004", name: "Duy", gpa: 65.0),
        Student(id: "S005", name: "Lan", gpa: 80.0)
    ]
    
    @State private var searchText: String = ""
    @State private var showOnlyHighGPA: Bool = false
    @State private var isSortedDescending: Bool = false
    
    // Filtering and sorting logic
    var filteredStudents: [Student] {
        var list = students
        
        if !searchText.isEmpty {
            list = list.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        // Filter students with GPA >= 80.0
        if showOnlyHighGPA {
            list = list.filter { $0.gpa >= 80.0 }
        }
        
        if isSortedDescending {
            list.sort { $0.gpa > $1.gpa }
        }
        
        return list
    }
    
    // Finds student with highest GPA
    var highestGPAStudent: Student? {
        students.max(by: { $0.gpa < $1.gpa })
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                // Search Field
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search student by name...", text: $searchText)
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray).opacity(0.15))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Top Student Highlight Card
                if let topStudent = highestGPAStudent {
                    HStack {
                        Image(systemName: "crown.fill")
                            .font(.title)
                            .foregroundColor(.yellow)
                        VStack(alignment: .leading) {
                            Text("Top Student")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(topStudent.name) (\(topStudent.id)) - GPA: \(String(format: "%.1f", topStudent.gpa))/100")
                                .font(.headline)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.15))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // Filter & Sort Toolbar
                HStack {
                    Toggle(isOn: $showOnlyHighGPA) {
                        Text("GPA ≥ 80")
                            .font(.subheadline)
                    }
                    .toggleStyle(.button)
                    
                    Spacer()
                    
                    Button(action: { isSortedDescending.toggle() }) {
                        HStack {
                            Image(systemName: "arrow.up.arrow.down")
                            Text(isSortedDescending ? "Unsort" : "Sort by GPA")
                        }
                        .font(.subheadline)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal)
                
                // Student List
                List {
                    ForEach(filteredStudents) { student in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(student.name)
                                    .font(.headline)
                                Text("ID: \(student.id)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("GPA: \(String(format: "%.1f", student.gpa))")
                                .font(.headline)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(student.gpa >= 80.0 ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                                .foregroundColor(student.gpa >= 80.0 ? .green : .orange)
                                .cornerRadius(8)
                        }
                    }
                    .onDelete(perform: deleteStudent)
                }
                
                // Navigation Link Button to Add Student View
                NavigationLink(destination: AddStudentView(students: $students)) {
                    Label("Add New Student", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Total Count Label
                Text("Total Students: \(students.count)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 8)
            }
            .navigationTitle("Student Manager")
        }
    }
    
    // Handles row deletion from List
    private func deleteStudent(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { filteredStudents[$0] }
        students.removeAll { student in
            itemsToDelete.contains(where: { $0.id == student.id })
        }
    }
}
