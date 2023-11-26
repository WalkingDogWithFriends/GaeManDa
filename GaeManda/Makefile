generate:
	tuist fetch
	TUIST_ROOT_DIR=${PWD} tuist generate --no-open

clean:
	rm -rf **/**/*.xcodeproj
	rm -rf *.xcworkspace

reset:
	rm -rf **/**/*.xcodeproj
	rm -rf *.xcworkspace
	tuist fetch
	TUIST_ROOT_DIR=${PWD} tuist generate --no-open
