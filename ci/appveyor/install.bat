@echo off

cd %APPVEYOR_BUILD_FOLDER%

echo Compiler: %COMPILER%
echo Architecture: %MSYS2_ARCH%
echo Platform: %PLATFORM%
echo MSYS2 directory: %MSYS2_DIR%
echo MSYS2 system: %MSYSTEM%
echo Configuration: %CONFIGURATION%
echo Target: %TARGET%

echo Start updating build dependencies...

IF %COMPILER%==msys2 (
  echo Installing MSYS2 build preconditions...

  @echo on

  echo Extending path to MSYS and MINGW...
  SET "PATH=C:\%MSYS2_DIR%\%MSYSTEM%\bin;C:\%MSYS2_DIR%\usr\bin;%PATH%"

  echo Updating pacman...
  bash -lc "pacman -S --needed --noconfirm pacman-mirrors"
  bash -lc "pacman -Syyu --noconfirm"

  echo Installing git...
  bash -lc "pacman -S --needed --noconfirm git"

  IF %BUILDTOOL%==meson (
    echo Installing ninja and meson build tool...
    bash -lc "pacman -S --needed --noconfirm mingw-w64-%MSYS2_ARCH%-meson"
  )

  IF %BUILDTOOL%==cmake (
    echo Installing cmake build tool...
    bash -lc "pacman -S --needed --noconfirm make mingw-w64-%MSYS2_ARCH%-cmake mingw-w64-%MSYS2_ARCH%-extra-cmake-modules"
  )

  echo Installing build and compile time dependencies...

  IF %TARGET%==importer (
    bash -lc "pacman -S --needed --noconfirm mingw-w64-%MSYS2_ARCH%-toolchain mingw-w64-%MSYS2_ARCH%-libtool mingw-w64-%MSYS2_ARCH%-libiconv mingw-w64-%MSYS2_ARCH%-libxml2 zip"

    cinst wget -x86

    wget https://github.com/rinigus/marisa-trie/archive/0.2.4.zip -O marisa.zip
    7z x marisa.zip
    bash -lc "cd ${APPVEYOR_BUILD_FOLDER} && cd marisa-trie-0.2.4 && ./configure --disable-shared && make -j2 && make install"

    wget https://github.com/google/protobuf/releases/download/v3.1.0/protobuf-cpp-3.1.0.zip -O protobuf-cpp-3.1.0.zip
    7z x protobuf-cpp-3.1.0.zip
    bash -lc "cd ${APPVEYOR_BUILD_FOLDER} && cd protobuf-3.1.0 && ./configure --disable-shared && make -j2 && make install"

  ) ELSE (
    echo Installing common dependencies
    bash -lc "pacman -S --needed --noconfirm mingw-w64-%MSYS2_ARCH%-protobuf mingw-w64-%MSYS2_ARCH%-libxml2 mingw-w64-%MSYS2_ARCH%-cairo mingw-w64-%MSYS2_ARCH%-pango mingw-w64-%MSYS2_ARCH%-qt5 mingw-w64-%MSYS2_ARCH%-glew mingw-w64-%MSYS2_ARCH%-glfw mingw-w64-%MSYS2_ARCH%-glm"
  )

  echo Finished installing MSYS2 build preconditions
)

IF %COMPILER%==msvc2019 (
  @echo on
  echo MSVC2019 build...

  set starttime=%time%

  IF %BUILDTOOL%==cmake (
    cd c:\tools\vcpkg

    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing zlib, iconv, libxml2...
      .\vcpkg install zlib:x64-windows libiconv:x64-windows libxml2:x64-windows
    )

    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing protobuf...
      .\vcpkg install protobuf:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing pixman, expat, fontconfig, cairo, harfbuzz, pango...
      .\vcpkg install pixman:x64-windows expat:x64-windows fontconfig:x64-windows cairo:x64-windows harfbuzz:x64-windows pango:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing double-conversion...
      .\vcpkg install double-conversion:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-modularscripts...
      .\vcpkg install qt5-modularscripts:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing openssl-windows, openssl...
      .\vcpkg install openssl-windows:x64-windows openssl:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing libpq...
      .\vcpkg install libpq:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing sqlite3...
      .\vcpkg install sqlite3:x64-windows
    )

    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-base...
      .\vcpkg install qt5-base:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-graphicaleffects...
      .\vcpkg install qt5-graphicaleffects:x64-windows
    )

    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-declarative...
      .\vcpkg install qt5-declarative:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-quickcontrols...
      .\vcpkg install qt5-quickcontrols:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-speech...
      .\vcpkg install qt5-speech:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-charts...
      .\vcpkg install qt5-charts:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-datavis3d...
      .\vcpkg install qt5-datavis3d:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-multimedia...
      .\vcpkg install qt5-multimedia:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-3d...
      .\vcpkg install qt5-3d:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-gamepad...
      .\vcpkg install qt5-gamepad:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-imageformats...
      .\vcpkg install qt5-imageformats:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-networkauth...
      .\vcpkg install qt5-networkauth:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-quickcontrols2...
      .\vcpkg install qt5-quickcontrols2:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-scxml...
      .\vcpkg install qt5-scxml:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-serialport...
      .\vcpkg install qt5-serialport:x64-windows
    )

    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-svg...
      .\vcpkg install qt5-svg:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-virtualkeyboard...
      .\vcpkg install qt5-virtualkeyboard:x64-windows
    )

    rem transitive
    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-websockets...
      .\vcpkg install qt5-websockets:x64-windows
    )

    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5...
      .\vcpkg install qt5:x64-windows
    )

    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing qt5-tools...
      .\vcpkg install qt5-tools:x64-windows
    )

    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing OpenGL...
      .\vcpkg install opengl:x64-windows
    )

    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing freeglut...
      .\vcpkg install freeglut:x64-windows
    )

    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing glm...
      .\vcpkg install glm:x64-windows
    )

    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing glew...
      .\vcpkg install glew:x64-windows
    )

    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo Installing glfw3...
      .\vcpkg install glfw3:x64-windows
    )

    %APPVEYOR_BUILD_FOLDER%\ci\timediff.cmd %starttime%
    if %timediff% LEQ 1800 (
      echo System-wide integrating vcpkg...
      .\vcpkg integrate install
    )

    cd %APPVEYOR_BUILD_FOLDER%
  )

  IF %BUILDTOOL%==meson (
    echo Installing meson build tool...
    set "PATH=C:\Python36-x64;C:\Python36-x64\Scripts;%PATH%"
    pip.exe install meson
    echo ...done
  )
)
