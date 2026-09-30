import SwiftUI

struct AddStudentView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var students: [Student]
    
    @State private var studentID: String = ""
    @State private var name: String = ""
    @State private var gpaString: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Student Information")) {
                TextField("Student ID (e.g., S001)", text: $studentID)
                TextField("Full Name", text: $name)
                TextField("GPA (0 - 100)", text: $gpaString)
            }
            
            Button(action: saveStudent) {
                Text("Save Student")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Add Student")
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Notice"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // Validates inputs and appends new student to array
    private func saveStudent() {
        let trimmedID = studentID.trimmingCharacters(in: .whitespaces)
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedID.isEmpty, !trimmedName.isEmpty else {
            alertMessage = "Please enter both Student ID and Full Name."
            showAlert = true
            return
        }
        
        // Validate GPA in 0 - 100 range
        guard let gpa = Double(gpaString), gpa >= 0.0, gpa <= 100.0 else {
            alertMessage = "GPA must be a valid number between 0 and 100."
            showAlert = true
            return
        }
        
        if students.contains(where: { $0.id == trimmedID }) {
            alertMessage = "Student ID '\(trimmedID)' already exists!"
            showAlert = true
            return
        }
        
        let newStudent = Student(id: trimmedID, name: trimmedName, gpa: gpa)
        students.append(newStudent)
        dismiss()
    }
}
