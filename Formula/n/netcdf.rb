class Netcdf < Formula
  desc "Libraries and data formats for array-oriented scientific data"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "ce160f9c1483b32d1ba8b7633d7984510259e4e439c48a218b95a023dc02fd4c"
  license "BSD-3-Clause"
  head "https://github.com/Unidata/netcdf-c.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:netcdf[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "10d18ec71ec26a605c4502a7d6d99773d47a7a51279e47ceea0461e4ad1abc2d"
    sha256 cellar: :any,                 arm64_sequoia: "cc9073c77ea2133b6559ba1945aa391e04d62d09b45d5c091f7121d220e1c616"
    sha256 cellar: :any,                 arm64_sonoma:  "bde7dbde9b474aaaf98748d1ecbfe11d52f7104712ba503875fa0fbe482e379a"
    sha256 cellar: :any,                 sonoma:        "3d06a5929ab8956cf299d73adaf04c85faa8794bc56f9026913b60a0adfe8f38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57f0217f3718aee8f6e78dd92f5b7d0cc7ad833c7a64b64925cc0e4825f13f97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a5e152ac7e674a5f82dccf48d377514d2364dc97b9841a9ea247dc9243cda58"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  uses_from_macos "m4" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "libaec"
    depends_on "zstd"
  end

  def install
    args = %w[-DNETCDF_ENABLE_TESTS=OFF -DNETCDF_ENABLE_HDF5=ON -DNETCDF_ENABLE_DOXYGEN=OFF]
    # Fixes "relocation R_X86_64_PC32 against symbol `stderr@@GLIBC_2.2.5' can not be used" on Linux
    args << "-DCMAKE_POSITION_INDEPENDENT_CODE=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build_shared", *args, "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
    system "cmake", "-S", ".", "-B", "build_static", *args, "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    lib.install "build_static/libnetcdf.a"

    # Remove shim paths
    inreplace [bin/"nc-config", lib/"pkgconfig/netcdf.pc", lib/"cmake/netCDF/netCDFConfig.cmake",
               lib/"libnetcdf.settings"], Superenv.shims_path/ENV.cc, ENV.cc
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "netcdf_meta.h"
      int main()
      {
        printf(NC_VERSION);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lnetcdf",
                   "-o", "test"
    assert_equal version.to_s, `./test`
  end
end
