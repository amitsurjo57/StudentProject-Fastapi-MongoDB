class AppService {
  static const _baseUrl =
      "https://student-project-flutter-fastapi-mongodb.up.railway.app";

  static String getStudentsByDepartment({required String department}) {
    return "$_baseUrl/students/$department";
  }

  static String searchStudent({required String department, required int roll}) {
    return "$_baseUrl/students/$department/$roll";
  }

  static String createStudent({required String department}) {
    return "$_baseUrl/students/$department";
  }

  static String deleteStudent({
    required String name,
    required String department,
    required int roll,
  }) {
    return "$_baseUrl/students/$department/$name/$roll";
  }

  static String updateStudent({
    required String name,
    required String department,
    required int roll,
  }) {
    return "$_baseUrl/students/$department/$name/$roll";
  }
}
