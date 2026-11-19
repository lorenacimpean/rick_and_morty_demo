import 'package:rick_and_morty_demo/core/network/app_exception.dart';

// The only place an AppErrorType becomes words.
extension AppErrorMessage on AppErrorType {
  String get message => switch (this) {
    .noConnection => 'No internet connection',
    .timeout => 'The request took too long',
    .notFound => 'Nothing found',
    .server => 'The server is having trouble. Try again later',
    .generic => 'Something went wrong',
  };
}
