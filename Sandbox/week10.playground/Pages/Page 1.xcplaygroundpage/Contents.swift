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
for name in students {
    
}

func attendedStudents () -> Array<String>{
    return students.map{$0.name}
}
print (attendedStudents())

//Q 나이의 총 합?
