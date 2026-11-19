# CI has no fvm and passes FLUTTER=flutter DART=dart.
FLUTTER := fvm flutter
DART := fvm dart

.PHONY: build clean analyze test integration

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
	$(DART) format --output=none --set-exit-if-changed lib test integration_test
	$(FLUTTER) analyze

# Unit tests, with coverage in coverage/lcov.info.
test:
	$(FLUTTER) test --coverage

# UI tests on the booted emulator or simulator (pass -d <device> via ARGS).
integration:
	$(FLUTTER) test integration_test $(ARGS)
