FLUTTER := fvm flutter
DART := fvm dart

.PHONY: build clean patrol

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

# UI tests on a booted emulator or simulator. patrol_cli uses the pinned Flutter.
patrol:
	PATROL_FLUTTER_COMMAND="$(FLUTTER)" patrol test
