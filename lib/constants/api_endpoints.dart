const String API_URL = 'http://10.0.2.2:3000/api'; // default android studio host
const String WS_URL = 'ws://10.0.2.2:3000/ws/quiz';
class ApiEndpoint {
  static const String loginEndpoint = '/auth/authenticate';
  static const String signupEndpoint = '/auth/signup';
  static const String quizzes = '/quizzes';
}