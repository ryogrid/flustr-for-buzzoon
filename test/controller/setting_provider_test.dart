import 'package:flustr/controller/setting_provider/servaddr_provider.dart';
import 'package:flutter_test/flutter_test.dart';

class _ValidateKeyTestInput {
  _ValidateKeyTestInput(this.input, this.description, this.expected);
  final String input;
  final String description;
  final bool expected;
}

void main() {
  group(
    'validateKeyのテスト郡',
    () {
      final tests = <_ValidateKeyTestInput>[
        _ValidateKeyTestInput(
          'npub10elfcs4fr0l0r8af98jlmgdh9c8tcxjvz9qkw038js35mp4dma8qzvjptg',
          'normal npub is valid',
          true,
        ),
        _ValidateKeyTestInput(
          'nsec1vl029mgpspedva04g90vltkh6fvh240zqtv9k0t9af8935ke9laqsnlfe5',
          'normal nsec is valid',
          true,
        ),
        _ValidateKeyTestInput(
          'hogehogehogehogehogeohge',
          'random words is invalid',
          false,
        ),
      ];
      for (final testcase in tests) {
        test(testcase.description, () {
          final got = validateKey(testcase.input);
          expect(got, testcase.expected);
        });
      }
    },
  );
}
