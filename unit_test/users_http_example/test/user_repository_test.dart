import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:users_http_example/user_model.dart';
import 'package:users_http_example/user_repository.dart';

class MockHTTPClient extends Mock implements Client {}

void main() {
  late UserRepository userRepository;
  late MockHTTPClient mockHTTPClient;

  setUp(
    () {
      mockHTTPClient = MockHTTPClient();
      userRepository = UserRepository(mockHTTPClient);
    },
  );
  group(
    "UserRepository -",
    () {
      group(
        "getUser function",
        () {
          test(
            "given UserRepository class when getUser function is called and statusCode equal to 200 then userModel should be returned",
            () async {
              // arrange
              when(
                () {
                  return mockHTTPClient.get(
                    Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
                  );
                },
              ).thenAnswer(
                (invocation) async {
                  return Response('''
                    {
                    "id": 1,
                    "name":"nabil mersni"
                    }
                  ''', 200);
                },
              );
              // act
              final user = await userRepository.getUser();
              // assert
              expect(user, isA<User>());
            },
          );

          test(
            "given UserRepository class when getUser function is called and statusCode is not 200 then an error must be thrown",
            () async {
              // arrange
              when(
                () {
                  return mockHTTPClient.get(
                    Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
                  );
                },
              ).thenAnswer(
                (invocation) async {
                  return Response('{}', 500);
                },
              );
              // act
              final user = userRepository.getUser();
              // assert
              expect(user, throwsException);
            },
          );
        },
      );
    },
  );
}
