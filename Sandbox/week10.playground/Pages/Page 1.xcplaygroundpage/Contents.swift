import UIKit

struct Student{
    let name: String
    let age: Int
    let attendence: Bool
}

var students = [
    Student(name: "Jane", age: 12, attendence: true),
    Student(name: "Minsu", age: 13, attendence: false),
    Student(name: "July", age: 10, attendence: true),
    Student(name: "Tom", age: 12, attendence: false),
    Student(name: "Mary", age: 10, attendence: true),
    Student(name: "David", age: 11, attendence: true)]

//Q.전체 학생의 이름?
var q1: [String] = Array()
for student in students {
    q1.append(student.name)
}
print(q1)


//Q 나이의 총 합?
var q2: Int = 0
for student in students {
    q2 += student.age
}
print(q2)
