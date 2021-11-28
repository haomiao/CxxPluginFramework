cmake_minimum_required(VERSION 3.16)
project(CxxPluginFramework VERSION 1.0.0)

# set cpp version
set(CMAKE_CXX_STANDARD 17)

set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)

set_property(GLOBAL PROPERTY USE_FOLDERS On)

if(IOS OR OSX OR ANDROID)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fno-omit-frame-pointer")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-omit-frame-pointer")
endif()

# set project directory
set(PROJECT_ROOT_DIR ${PROJECT_SOURCE_DIR})
set(PROJECT_CORE_DIR ${PROJECT_SOURCE_DIR}/core)

set(WARNING_AS_ERROR_ENABLE TRUE)

if(MSVC)
  # Code Generation - Runtime Libray option.
  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MD")
  set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /MD")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MDd")
  set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /MDd")
endif()

if(WARNING_AS_ERROR_ENABLE)
  if("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
    # using Clang
    message(STATUS "CLang detected, adding compile flags")
    remove_definitions("-w")
    add_definitions("-Wall -Wuninitialized -Werror")
  elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    # using GCC
    message(STATUS "GCC detected, adding compile flags")
  elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
    # using Intel C++
    message(STATUS "Intel detected, adding compile flags")
  elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    # using Visual Studio C++
    message(STATUS "MSVC detected, adding compile flags")
    # 4996:废弃方法
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4100 /wd4505 /wd4996")
    add_definitions("/W4 /WX")
  endif()
endif()

if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Zi")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /Zi")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /EHsc /sdl /Gy")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /EHsc /sdl /Gy")
  set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} /DEBUG /OPT:REF /OPT:ICF")
  # 多处理器编译
  add_definitions("/MP")
endif()

if(IOS OR OSX)
  # override cmake add_library method to set property for all target do not override add_library for more than once, or segmentation fault will
  # occured, so place this code before all other add_library call. note that add_library is equal ADD_LIBRARY.
  function(add_library _target)
    # message(STATUS "enter add_library override: _target='${_target}'")
    _add_library(${_target} ${ARGN})

    set(extra_macro_args ${ARGN})
    list(LENGTH extra_macro_args num_extra_args)
    # avoid setting target less than one file and imported target.
    if((${num_extra_args} GREATER 1) AND (NOT (ARGV2 STREQUAL "IMPORTED")))
      if(APPLE)
        set_xcode_attr_property(${_target} DEBUG_INFORMATION_FORMAT "dwarf-with-dsym")
        set_xcode_attr_property(${_target} GCC_GENERATE_DEBUGGING_SYMBOLS "YES")
        # 3 means -O3, other value 2 -O2, 0 -O0, s -Os (fastest, smallest)
        set_xcode_attr_property(${_target} GCC_OPTIMIZATION_LEVEL[variant=Release] s)
        set_xcode_attr_property(${_target} GCC_INLINES_ARE_PRIVATE_EXTERN[variant=Release] "YES")
        # set_xcode_attr_property(${_target} GCC_SYMBOLS_PRIVATE_EXTERN "YES")
        set_xcode_attr_property(${_target} DEAD_CODE_STRIPPING[variant=Release] "YES")

      endif(APPLE)
      if(IOS)
        set_xcode_attr_property(${_target} VALID_ARCHS "arm64 armv7")
        set_xcode_attr_property(${_target} VALID_ARCHS[sdk=iphonesimulator*] "x86_64")
        set_xcode_attr_property(${_target} ONLY_ACTIVE_ARCH[variant=Debug] "YES")
      endif(IOS)
    endif()
  endfunction()
endif()

if(WIN32)
  set(CPF_EXE_OUTPUT_DIRECTORY "${PROJECT_ROOT_DIR}/bin/$<CONFIG>")
  set(CPF_OUTPUT_DIRECTORY "${CPF_EXE_OUTPUT_DIRECTORY}/sdk")
  set(CPF_LIB_OUTPUT_DIRECTORY "${CPF_OUTPUT_DIRECTORY}/libs")
  set(CPF_PLUGINS_OUTPUT_DIRECTORY "${CPF_OUTPUT_DIRECTORY}/plugins")

  link_directories(${LIVE_SDK_LIB_OUTPUT_DIRECTORY})

  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CPF_OUTPUT_DIRECTORY}")
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CPF_LIB_OUTPUT_DIRECTORY}")
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CPF_LIB_OUTPUT_DIRECTORY}")

  set(CPF_COMPANY_NAME "Custom")
  set(CPF_PRODUCT_NAME "Custom SDK")
  set(CPF_COMMENTS "Custom sdk, Easy to use.")
  set(CPF_LEGAL_COPYRIGHT "(C) Custom")

endif(WIN32)

add_subdirectory(core)
add_subdirectory(app)
