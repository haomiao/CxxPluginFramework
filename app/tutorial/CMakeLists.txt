cmake_minimum_required (VERSION 3.16)

project(tutorial)

set(INCLUDE_DIRECTORY
    .
    ${PROJECT_CORE_DIR}
)

if(WIN32)
	set(SDK_VERSION_MAJOR 1)
	set(SDK_VERSION_MINOR 0)
	set(SDK_VERSION_PATCH 0)
	set(SDK_VERSION_STR "1.0.0")
	set(CPF_MODULE_DESCRIPTION "CxxPluinFramework Tutorial")
	configure_file(${PROJECT_ROOT_DIR}/common.rc.in ${PROJECT_BINARY_DIR}/tutorial.rc)
endif()

set(CMAKE_CXX_STANDARD 17)


include_directories(${INCLUDE_DIRECTORY})
add_definitions(-DUNICODE -D_UNICODE)
add_definitions("/W4 /WX-")
set_property(GLOBAL PROPERTY USE_FOLDERS On)


set(tutorial_SOURCES
    "app.cc"
	${PROJECT_BINARY_DIR}/tutorial.rc
)

set(tutorial_HEADERS
    "app.h"
)

source_group("include" FILES ${tutorial_HEADERS})
source_group("src" FILES ${tutorial_SOURCES})

add_definitions(-DUNICODE -D_UNICODE)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CPF_EXE_OUTPUT_DIRECTORY})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CPF_LIB_OUTPUT_DIRECTORY})

if(WIN32)
add_executable(tutorial WIN32
    ${tutorial_HEADERS}
    ${tutorial_SOURCES}
)

Set_Target_Properties(tutorial PROPERTIES LINK_FLAGS "/subsystem:windows /ENTRY:mainCRTStartup")
endif(WIN32)

#if(WIN32)
#  add_custom_command(TARGET tutorial PRE_BUILD
#  )
  
#  add_custom_command(TARGET tutorial POST_BUILD
#  )
#endif(WIN32)
