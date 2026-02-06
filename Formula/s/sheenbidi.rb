class Sheenbidi < Formula
  desc "Fast and stable implementation of the Unicode Bidirectional Algorithm"
  homepage "https://github.com/Tehreer/SheenBidi"
  url "https://github.com/Tehreer/SheenBidi/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "e90ae142c6fc8b94366f3526f84b349a2c10137f87093db402fe51f6eace6d13"
  license "Apache-2.0"

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
