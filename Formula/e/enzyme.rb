class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.246.tar.gz"
  sha256 "73d68edd893828698dbf93e01baa613a66774de1c75755332fcf210996b16d43"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cfd96e1b8819c3cfffe1fa090dd624b0f0eaef6ef6351595f861e0e6c291c13e"
    sha256 cellar: :any,                 arm64_sequoia: "145d0b4dc362267d604c1e2dbac6ff15a9b589b5a38c92784c5600f502d60f86"
    sha256 cellar: :any,                 arm64_sonoma:  "d08ac0207bfbd0024ffdf475d2dd9b4c3fe80680f0f905e8b46c3d936e687389"
    sha256 cellar: :any,                 sonoma:        "0bd525648d82f8e629f11baf9b1f78c687a48cdc91b10465c4dbba640cdaea64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c51c30eecb6aef9a53bb473b79442f0b60fd1ccce2c1a7c28f369bb489d9f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b39609cc6970c65f47873cc12e730aafa0ddf08a768e8393cc7a21cd5c2fb0ee"
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
