cmake_minimum_required(VERSION 2.8)

# mine
include_directories(".")

# link external libraries
set(libs "dl")

# list of source files to be compiled
file(GLOB SRCS *.cpp)

add_library (${PROJECT_NAME}_${CMAKE_BUILD_TYPE} SHARED
	${SRCS}
)

if (CMAKE_BUILD_TYPE STREQUAL "DebugProfile")
    add_library (${PROJECT_NAME}_p${CMAKE_BUILD_TYPE} STATIC
        ${SRCS}
    )
    set_target_properties(${PROJECT_NAME}_p${CMAKE_BUILD_TYPE} PROPERTIES COMPILE_FLAGS "-fprofile-arcs -ftest-coverage")
    #set(libs, "${libs} gcov")
    target_link_libraries (${PROJECT_NAME}_p${CMAKE_BUILD_TYPE}
        ${libs}
        ${Boost_LIBRARIES}
    )
endif()


target_link_libraries (${PROJECT_NAME}_${CMAKE_BUILD_TYPE}
    ${libs}
    ${Boost_LIBRARIES}
)

add_subdirectory( tests )

# done.
