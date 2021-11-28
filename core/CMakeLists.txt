cmake_minimum_required(VERSION 3.16)
project(core)

# set cpp version
set(CMAKE_CXX_STANDARD 17)

if(WARNING_AS_ERROR_ENABLE)
  if(MSVC)
    remove_definitions("/W3")
    add_definitions("/W4 /wd4100 /wd4505 /wd4819")
  endif()
endif()

#add_subdirectory(plugin)

#set(SDK_PROJECTS
#     core
#)

#set_target_properties(
#	${SDK_PROJECTS}
#	PROPERTIES FOLDER "core"
#)
