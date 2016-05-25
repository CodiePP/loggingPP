#!/bin/sh

for HPP in `../../../gitalk/utils/find_hpp.sh ../../Code/Cpp/loggingpp.md`; do
  ../../../gitalk/utils/make_hpp.sh ${HPP}
  ../../../gitalk/utils/make_cpp.sh ${HPP}
done


cd tests

../../../../gitalk/utils/make_test.sh  ../../../Code/Cpp/tests/utloggingpp.md 

for HPP in `../../../../gitalk/utils/find_hpp.sh ../../../Code/Cpp/tests/mocksloggingpp.md`; do 
  ../../../../gitalk/utils/make_hpp.sh ${HPP}
  ../../../../gitalk/utils/make_cpp.sh ${HPP}
done


cd ..
