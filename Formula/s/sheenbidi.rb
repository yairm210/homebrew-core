class Sheenbidi < Formula
  desc "Fast and stable implementation of the Unicode Bidirectional Algorithm"
  homepage "https://github.com/Tehreer/SheenBidi"
  url "https://github.com/Tehreer/SheenBidi/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "e90ae142c6fc8b94366f3526f84b349a2c10137f87093db402fe51f6eace6d13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "937f494d35e17ea7329000a4b2a65e44c40687b86f7116c7e4fd6841ffecb18f"
    sha256 cellar: :any,                 arm64_sequoia: "8118d771952be49ca04efaaabbecae4b9b7abd5c8fd6d8a8581d4f4effe48f37"
    sha256 cellar: :any,                 arm64_sonoma:  "254ff65fa1488865559fea8e76b2fb11f7fdf0053523f5fcc05314f6901a43a7"
    sha256 cellar: :any,                 sonoma:        "2ae51b809fb3cccce63f59055a15ad85fa7abb6b509f05f697878fae2af4aa0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a7beddd0917b9af373f2d6ddfc581497551d8558cd04a5d401ed6ffbb9eea71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed7320cea30ff43f03a54904ed3c4df20ae5f098da6bfe6c8bc42e55a92f858c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    args = [
      "-DBUILD_SHARED_LIBS=ON",
      "-DSB_CONFIG_UNITY=ON",
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <SheenBidi/SheenBidi.h>

      int main() {
        const char *version = SBVersionGetString();
        return 0;
      }
    C

    system ENV.cc, "test.c",
                   "-I#{include}",
                   "-L#{lib}", "-lSheenBidi",
                   "-o", "test"
    system "./test"
  end
end
