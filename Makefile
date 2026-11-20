# CI has no fvm and passes FLUTTER=flutter DART=dart.
FLUTTER := fvm flutter
DART := fvm dart

.PHONY: build clean analyze test coverage integration

# Fetches packages and generates the freezed and json code.
build:
	$(FLUTTER) pub get
	$(DART) run build_runner build

# Removes build output, generated code and native caches. Run make build after.
clean:
	$(FLUTTER) clean
	find lib test \( -name '*.g.dart' -o -name '*.freezed.dart' \) -delete
	rm -rf ios/Pods ios/Podfile.lock ios/.symlinks ios/build
	rm -rf android/.gradle android/build android/app/build android/.cxx android/app/.cxx

# Fails on unformatted code or analyzer issues, like CI.
analyze:
	$(DART) format --output=none --set-exit-if-changed lib test integration_test tool
	$(FLUTTER) analyze

# Unit tests, with coverage in coverage/lcov.info.
test:
	$(FLUTTER) test --coverage

# Coverage without generated code and previews, as HTML in coverage/html (needs lcov).
coverage: test
	lcov --quiet --remove coverage/lcov.info '*.g.dart' '*.freezed.dart' '*_previews.dart' '*/app_preview.dart' \
		--ignore-errors unused,unused,empty,empty --output-file coverage/lcov.info
	genhtml --quiet coverage/lcov.info --output-directory coverage/html

# UI tests on the booted emulator or simulator (pass -d <device> via ARGS).
integration:
	$(FLUTTER) test integration_test $(ARGS)
