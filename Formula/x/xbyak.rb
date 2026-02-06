class Xbyak < Formula
  desc "C++ JIT assembler for x86 (IA32), x64 (AMD64, x86-64)"
  homepage "https://github.com/herumi/xbyak"
  url "https://github.com/herumi/xbyak/archive/refs/tags/v7.31.tar.gz"
  sha256 "f939ee2ebd54bdbad9a1cde0fe0032b142df164b931c11a42dd96a423f996445"
  license "BSD-3-Clause"
  head "https://github.com/herumi/xbyak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c453b15fc95aaa8727c66eb8d8e19c4d94cd5ed2d83790acd0c86c6b116e560"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <xbyak/xbyak_util.h>

      int main() {
        Xbyak::util::Cpu cpu;
        cpu.has(Xbyak::util::Cpu::tSSE42);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-c", "-I#{include}"
  end
end
