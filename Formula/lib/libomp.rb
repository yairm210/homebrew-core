class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.0/llvm-project-22.1.0.src.tar.xz"
  sha256 "25d2e2adc4356d758405dd885fcfd6447bce82a90eb78b6b87ce0934bd077173"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f17743694c23ce1399072245d095a684949c2e7b2dc79987ecc73146e04b5ad2"
    sha256 cellar: :any,                 arm64_sequoia: "dec193f677987567ad53b3e8578dd4b0aeba7c94aa3216d171429fe918f9e0ea"
    sha256 cellar: :any,                 arm64_sonoma:  "9e6d77824cdc54f8d85b19004f648d66da605f27646d2103427687ce3cd5d8ec"
    sha256 cellar: :any,                 sonoma:        "7e74c248fcec32091fab20bbfd9d1ea59a8d00c25572bdaedc79831205f600a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9250c7590b8c27138aa59e7ab2b419b3389c2a94dce0f226e95c4e1d7bd0b8eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34712b7cdaedb8702bf6799e838257302d1d5e7ccc132f251572ceeb48a3a26e"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  depends_on "lit" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "python@3.14"
  end

  def install
    # Disable LIBOMP_INSTALL_ALIASES, otherwise the library is installed as
    # libgomp alias which can conflict with GCC's libgomp.
    args = ["-DLIBOMP_INSTALL_ALIASES=OFF"]
    args << "-DOPENMP_ENABLE_LIBOMPTARGET=OFF" if OS.linux?

    system "cmake", "-S", "openmp", "-B", "build/shared", *std_cmake_args, *args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "openmp", "-B", "build/static",
                    "-DLIBOMP_ENABLE_SHARED=OFF",
                    *std_cmake_args, *args
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <omp.h>
      #include <array>
      int main (int argc, char** argv) {
        std::array<size_t,2> arr = {0,0};
        #pragma omp parallel num_threads(2)
        {
            size_t tid = omp_get_thread_num();
            arr.at(tid) = tid + 1;
        }
        if(arr.at(0) == 1 && arr.at(1) == 2)
            return 0;
        else
            return 1;
      }
    CPP
    system ENV.cxx, "-Werror", "-Xpreprocessor", "-fopenmp", "test.cpp", "-std=c++11",
                    "-I#{include}", "-L#{lib}", "-lomp", "-o", "test"
    system "./test"
  end
end
