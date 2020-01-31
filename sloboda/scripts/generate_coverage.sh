flutter packages pub run test ./test/citybuilding --coverage=./coverage
format_coverage --packages=.packages --report-on lib -i ./coverage/test/citybuilding/*.* -o ./coverage/lcov.info -l
genhtml -o coverage ./coverage/lcov.info