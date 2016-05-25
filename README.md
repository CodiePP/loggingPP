# logging in C++

## generate source code
go to the code directory and run the script:
```
cd loggingPP
cd src/Cpp
./mk_loggingpp.sh
```

## compile
back in the root directory of the project
```
cmake -D CMAKE_BUILD_TYPE=Debug .
make -j 4
```

## unit tests

```
cd src/Cpp/tests
./run_tests.sh
```

## license

[GPLv3](LICENSE)

