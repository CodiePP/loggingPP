#!/bin/bash

./tests/UT_loggingPP --list_content > ut.list 2>&1

./tests/UT_loggingPP --log_level=all --report_level=short


