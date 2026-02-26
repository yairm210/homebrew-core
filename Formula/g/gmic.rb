class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_3.7.1.tar.gz"
  sha256 "5bad05dbe3d1fb0bdb33de79618bcf51ebe8605b1342e149e3bd7375d3caf141"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "81adf04c73b2fb210234d31e5ff1fe3f9879cf477bcdccf94a8e941c5e1ef355"
    sha256 cellar: :any,                 arm64_sequoia: "297028ab30da2e2f0d0ead98eb90cb77817fee5b4db99cf032954d56c21a782b"
    sha256 cellar: :any,                 arm64_sonoma:  "5ff4f9d6b8208a226cd879416d54f64636e1d31d1d579f5ef87e07737abfbe64"
    sha256 cellar: :any,                 sonoma:        "dab173320c39efa77e823c2ecdabd74975ef6c802b475333733d6fea418e6117"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae7e5473d3fe2177681a159f3ac8530207ab5f1e9f7fa0c34776b44567ea50ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c19e55045032ae82e209b8bb25981987786cc3a1f907d8354af12ba2e6812e13"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cimg"
  depends_on "fftw"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

  uses_from_macos "curl"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "libx11"
    depends_on "zlib-ng-compat"
  end

  def install
    rm "src/CImg.h" if build.stable?

    args = %W[
      -DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}
      -DENABLE_DYNAMIC_LINKING=ON
      -DENABLE_FFMPEG=OFF
      -DENABLE_GRAPHICSMAGICK=OFF
      -DUSE_SYSTEM_CIMG=ON
    ]
    if OS.mac?
      args << "-DENABLE_X=OFF"
      inreplace "CMakeLists.txt", "COMMAND LD_LIBRARY_PATH", "COMMAND DYLD_LIBRARY_PATH"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    %w[test.jpg test.png].each do |file|
      system bin/"gmic", test_fixtures(file)
    end
    system bin/"gmic", "-input", test_fixtures("test.jpg"), "rodilius", "10,4,400,16",
           "smooth", "60,0,1,1,4", "normalize_local", "10,16", "-output", testpath/"test_rodilius.jpg"
    assert_path_exists testpath/"test_rodilius.jpg"
  end
end
