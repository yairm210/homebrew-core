class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.248.tar.gz"
  sha256 "bc8f467336f1b188ee4682c4d5fca24e72eeb56b3c1fae804580c6668b0d190e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f30b8d5764a051dbc96b0d035f301ab5161a2e1e525cf5ab4db36638d440182b"
    sha256 cellar: :any,                 arm64_sequoia: "86973fc585f29301e3f637580956ec9a2d406df102f9abba0cb95b0df0ac515a"
    sha256 cellar: :any,                 arm64_sonoma:  "fdfcd34b5361585683ae689d5adf221ca1a5ae76a28555bd5cf05d2d17c44633"
    sha256 cellar: :any,                 sonoma:        "06bd7f31d4267c5c54c150e849d500108eda59f5c3200db44a4b84df2b993924"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ef611f79f838d4aa84b5405deae9f81b97dab03edc9053a52b45b78d7e5b610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f4d847c6bf4fad4d028d562ef7a2de492b7d3e1a981410ad9d025150a1d42e7"
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
