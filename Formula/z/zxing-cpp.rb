class ZxingCpp < Formula
  desc "Multi-format barcode image processing library written in C++"
  homepage "https://github.com/zxing-cpp/zxing-cpp"
  url "https://github.com/zxing-cpp/zxing-cpp/releases/download/v3.0.1/zxing-cpp-3.0.1-homebrew.tar.gz"
  sha256 "c0f210924955785004150c71d77306da8c6461b5db6abdb323fc331d6a213876"
  license "Apache-2.0"
  head "https://github.com/zxing-cpp/zxing-cpp.git", branch: "master"

  depends_on "cmake" => :build

  def install
    args = %w[
      -DZXING_C_API=OFF
      -DZXING_EXAMPLES=OFF
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
  end
end
