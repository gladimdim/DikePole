flutter packages pub run test ./test/citybuilding/sloboda_test.dart --coverage=./coverage/sloboda
flutter packages pub run test ./test/citybuilding/resource_building_test.dart --coverage=./coverage/resource_building
flutter packages pub global run coverage:format_coverage --packages=.packages --report-on lib -i ./coverage/sloboda/test/citybuilding/sloboda_test.dart.vm.json -o ./coverage/sloboda/lcov.info -l
flutter packages pub global run coverage:format_coverage --packages=.packages --report-on lib -i ./coverage/resource_building/test/citybuilding/resource_building_test.dart.vm.json -o ./coverage/resource_building/lcov.info -l
genhtml -o coverage ./coverage/sloboda/lcov.info ./coverage/resource_building/lcov.info