class Cwalk < Formula
  desc "Cross-platform path library for C/C++"
  homepage "https://likle.github.io/cwalk/"
  url "https://github.com/likle/cwalk/archive/refs/tags/v1.2.9.tar.gz"
  sha256 "54f160031687ec90a414e0656cf6266445207cb91b720dacf7a7c415d6bc7108"
  license "MIT"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=1", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOF
      #include <stdio.h>
      #include <cwalk.h>

      int main(int argc, char *argv[]) {
        const char *progname = NULL;
        cwk_path_get_basename(argv[0], &progname, NULL);
        printf("%s\\n", progname);
        return 0;
      }
    EOF

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcwalk", "-o", "test"
    assert_equal "test\n", shell_output("./test")
  end
end
