proto: flaska.proto
	@clang-format --style=file -i flaska.proto
	@protoc --dart_out=. $<

setup:
	flutter pub global activate protoc_plugin \^21.0.0
