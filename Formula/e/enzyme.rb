class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.249.tar.gz"
  sha256 "0842c14bd3953502bda6e8bdff22e94f3d49b042839f2ae5c3d502a7686ab969"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49aaf8e582562ef1643972c11a9fc7a32b058a32c98ccf02e1101accaa5a5497"
    sha256 cellar: :any,                 arm64_sequoia: "7456768e5c3f7ef171f96aa603ce2e986a294c0983c7eed933161f62e954fa99"
    sha256 cellar: :any,                 arm64_sonoma:  "5a8264c18222507b08ce0d28bfec7a2b5b14fcd2cca0b7e907bd25c91806a73b"
    sha256 cellar: :any,                 sonoma:        "f5cf1dbab8d7cbf38453a9144fe05f986925f9f8f349171ec7dfe791d5f57f4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca4ca937db439c736c13cb42e22da0f8183ffb9fcc15c3feafd2e8e633725894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "820f9839b6e2b258fd786eb738ee10142d77cc4ebcde220d79fbb46a2ca35ba9"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      extern double __enzyme_autodiff(void*, double);
      double square(double x) {
        return x * x;
      }
      double dsquare(double x) {
        return __enzyme_autodiff(square, x);
      }
      int main() {
        double i = 21.0;
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f\\n", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c",
                        "-fplugin=#{lib/shared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
