{ stdenv, lib, fetchFromGitHub
, llvm, clang, clang-unwrapped
, cmake
}:
stdenv.mkDerivation rec {
  pname = "hipify-clang";
  version = "4.3.0";
  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "HIPIFY";
    rev = "rocm-${version}";
    sha256 = "sha256-4SKMp8ena42sBfYI4DzahQuOUrEf/i2YoVQLP0Q3nk8=";
  };
  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ llvm clang clang-unwrapped ];

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=clang"
    "-DCMAKE_CXX_COMPILER=clang++"
  ];

  preConfigure = ''
    sed -i -e "s@set(CMAKE_C.*@#set(CMAKE_C@" CMakeLists.txt
  '';
  postInstall = ''
    mkdir $out/bin
    mv $out/hipify-clang $out/bin
  '';
}