cmake_minimum_required(VERSION 2.8)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

IF(DEFINED CMAKE_BUILD_TYPE)
	SET(CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE} CACHE STRING "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release DebugProfile RelWithDebInfo MinSizeRel.")
ELSE()
	SET(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release DebugProfile RelWithDebInfo MinSizeRel.")
ENDIF()

add_definitions( -DLinux )
#add_definitions( -DFreeBSD )
#add_definitions( -DWindows )

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
