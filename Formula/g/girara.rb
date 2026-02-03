class Girara < Formula
  desc "Common components for zathura"
  homepage "https://pwmt.org/projects/girara/"
  url "https://pwmt.org/projects/girara/download/girara-2026.02.04.tar.xz"
  sha256 "342eca8108bd05a2275e3eacb18107fa3170fa89a12c77e541a5f111f7bba56d"
  license "Zlib"

  livecheck do
    url "https://pwmt.org/projects/girara/download/"
    regex(/girara[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "78eae9047c4bc39c850ff0bcb08ec4c228be84865ff779a0437e1682ee2fe763"
    sha256 arm64_sequoia: "f0e9bb68e67a9ff733271d9103f8de0bc46730820ed34e2d21faccf66a2cabb3"
    sha256 arm64_sonoma:  "22b9f1e20f068be6a223f76fa74339aebd95338afc60e80c2d4206be18052f86"
    sha256 sonoma:        "491db29cb77b763e4b1724dd941afb2527b021a74223d60e8a3051c349099378"
    sha256 arm64_linux:   "34e14e9838a09ff6d4f7d0dea58f5ed80e18c8b4f470bb3dfb6d189811c20336"
    sha256 x86_64_linux:  "a9734fdd96abbd5aabe87ad763539707bb7ba0da2cc21a31af80cf1649b340d5"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"

  def install
    system "meson", "setup", "build", "-Ddocs=disabled", "-Dtests=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <girara/girara.h>

      int main(void) {
        GiraraTemplate* obj = girara_template_new("home@test@");
        girara_template_add_variable(obj, "test");
        girara_template_set_variable_value(obj, "test", "brew");
        char* result = girara_template_evaluate(obj);
        g_object_unref(obj);
        if (result == NULL) return 1;
        printf("%s", result);
        g_free(result);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", *shell_output("pkgconf --cflags --libs girara").chomp.split
    assert_equal "homebrew", shell_output("./test")
  end
end
