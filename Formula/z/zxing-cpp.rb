class ZxingCpp < Formula
  desc "Multi-format barcode image processing library written in C++"
  homepage "https://github.com/zxing-cpp/zxing-cpp"
  license "Apache-2.0"
  head "https://github.com/zxing-cpp/zxing-cpp.git", branch: "master"

  stable do
    url "https://github.com/zxing-cpp/zxing-cpp/releases/download/v3.0.2/zxing-cpp-3.0.2.tar.gz"
    sha256 "e957f13e2ad4e31badb3d9af3f6ba8999a3ca3c9cc4d6bafc98032f9cce1a090"

    # add support for homebrew specific STB_IMAGE_INCLUDE_DIR config option
    patch do
      url "https://github.com/zxing-cpp/zxing-cpp/commit/764f7ac3438f0e7638da27ad00cc2147312a2ea6.patch?full_index=1"
      sha256 "2174f23e784b8fd68a5f0b3fdf467f9c22c448b73ca40133be711486dfe8d82b"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "18ea1b16214084445c7e74b143d4985aba52702a4ebf0523b5e7b930271d7a52"
    sha256 cellar: :any,                 arm64_sequoia: "2a9611050e2026b1aa591b390b609f55f45b2465b03f255305e6f2a0d7ed91e5"
    sha256 cellar: :any,                 arm64_sonoma:  "9d1a9af0311577b559b455d032dc1c92e9b0157afba42e80c0658c0a0c0944f1"
    sha256 cellar: :any,                 sonoma:        "f2b04a8b3053dc47035220d526df7bf851c0140c1acae7c7a213758bc37e5f58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "168aa61e7cbb561fb6de96986d0765beea11a4f3d1bf78332029423835d678ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68d0c01fed83e9bca106bd13ded01f19c95d6a9a541463a14b270c3163354079"
  end

  depends_on "cmake" => :build

  resource "stb_image" do
    url "https://raw.githubusercontent.com/nothings/stb/013ac3beddff3dbffafd5177e7972067cd2b5083/stb_image.h"
    version "2.30"
    sha256 "594c2fe35d49488b4382dbfaec8f98366defca819d916ac95becf3e75f4200b3"
  end

  resource "stb_image_write" do
    url "https://raw.githubusercontent.com/nothings/stb/1ee679ca2ef753a528db5ba6801e1067b40481b8/stb_image_write.h"
    version "1.16"
    sha256 "cbd5f0ad7a9cf4468affb36354a1d2338034f2c12473cf1a8e32053cb6914a05"
  end

  def install
    resources.each do |r|
      r.stage do
        (include/"stb").install "#{r.name}.h"
      end
    end

    args = %W[
      -DZXING_DEPENDENCIES=LOCAL
      -DSTB_IMAGE_INCLUDE_DIR=#{include}/stb
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ZXing/ZXingCpp.h>
      int main() {
        ZXing::ReaderOptions options;
        (void)options;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++20", "-I#{include}", "-L#{lib}", "-lZXing", "-o", "test"
    system "./test"

    assert_match version.to_s, shell_output("#{bin}/ZXingReader --version")
  end
end
