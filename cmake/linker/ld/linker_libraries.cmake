# Copyright (c) 2024 Nordic Semiconductor
#
# SPDX-License-Identifier: Apache-2.0

set_linker_property(NO_CREATE TARGET linker PROPERTY c_library    "-lc")
set_linker_property(NO_CREATE TARGET linker PROPERTY rt_library   "-lgcc")
set_linker_property(NO_CREATE TARGET linker PROPERTY c++_library  "-lstdc++")
set_linker_property(NO_CREATE TARGET linker PROPERTY math_library "-lm")

if(CONFIG_CPP
   AND NOT CONFIG_MINIMAL_LIBCPP
   AND NOT CONFIG_NATIVE_LIBRARY
   # When new link principle is fully introduced, then the below condition can
   # be removed, and instead the external module c++ should use:
   # set_property(TARGET linker PROPERTY c++_library  "<external_c++_lib>")
   AND NOT CONFIG_EXTERNAL_MODULE_LIBCPP
)
  set_property(TARGET linker PROPERTY link_order_library "c++")
endif()


if(CONFIG_NEWLIB_LIBC AND CMAKE_C_COMPILER_ID STREQUAL "GNU")
  # We are using c;rt;c (expands to '-lc -lgcc -lc') in code below.
  # This is needed because when linking with newlib on aarch64, then libgcc has a
  # link dependency to libc (strchr), but libc also has dependencies to libgcc.
  # Lib C depends on libgcc. e.g. libc.a(lib_a-fvwrite.o) references __aeabi_idiv
  set_property(TARGET linker APPEND PROPERTY link_order_library "math;c;rt;c")
else()
  set_property(TARGET linker APPEND PROPERTY link_order_library "c;rt")
endif()
