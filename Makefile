FLUTTER := fvm flutter
DART := fvm dart

.PHONY: build clean

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
