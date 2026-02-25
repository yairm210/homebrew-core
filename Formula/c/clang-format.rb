class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.0/llvm-project-22.1.0.src.tar.xz"
  sha256 "25d2e2adc4356d758405dd885fcfd6447bce82a90eb78b6b87ce0934bd077173"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26dc592e1f1a8d9dd7923e12c7b080228f273f9eaca9032d7a259e72c4f6c227"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "242cf67bb85e7d28a372a94cc60419c6b9f76833ab5a89a23c068b5cad14ce83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d23e383f618a00829edcdefcf5dba6ed540ebd6b5da0c6760aebeff6f13625ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "299fb37203ee17a13e20d11a10a7796ec25ba96f64819f9cbef62dfe44a154c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "104f6d0e6e8b740b897ebbb60b7cd3ecc6f725f65169c49f8abeb7ad61d125ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30bcb264a642475ac34734670e548874eaaa46ba1204a0f276befe835b510559"
  end

  depends_on "cmake" => :build

  uses_from_macos "python"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  def install
    system "cmake", "-S", "llvm", "-B", "build",
                    "-DLLVM_ENABLE_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"
    system "cmake", "--install", "build", "--component", "clang-format"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~C
      int         main(char *args) { \n   \t printf("hello"); }
    C
    system "git", "add", "test.c"

    assert_equal <<~C, shell_output("#{bin}/clang-format -style=Google test.c")
      int main(char* args) { printf("hello"); }
    C

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end
