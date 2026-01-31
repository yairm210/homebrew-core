class Thorvg < Formula
  desc "Lightweight portable library used for drawing vector-based scenes and animations"
  homepage "https://www.thorvg.org"
  url "https://github.com/thorvg/thorvg/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "134a24aeb84988c36d188d6cabb62521b5186ae09d7f26a0bb807a1bab51439b"
  license "MIT"
  head "https://github.com/thorvg/thorvg.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9d87490684470b10afc64c6fe45a03468145bed36759cf41365e04352953ee24"
    sha256 cellar: :any,                 arm64_sequoia: "69d5298cd5ac913d954b5ee999023788c0db21d00c5e63de95c79aea3a64e783"
    sha256 cellar: :any,                 arm64_sonoma:  "a8ccd6d8af86d06fb8c5f782185b3b6e70d29d9cf00b03eeded13eba58c3bad2"
    sha256 cellar: :any,                 sonoma:        "653d87f6b405b6f5aa45abc702f25fab2200d2f8ab5c3f86b079b8404931747a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0138144a2810b47dcebdba850819b1f1b50c04ad303f829014fae922e8470b17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aab00cb963c786ef524be4a1550989521a9970beb22d4265888df40e099a1f55"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  on_macos do
    depends_on "libomp"
  end

  def install
    args = %w[
      -Dengines=sw
      -Dloaders=all
      -Dsavers=all
      -Dbindings=capi
      -Dthreads=true
      -Dlog=false
      -Dtests=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match version.to_s, shell_output("pkgconf --modversion thorvg-1")

    (testpath/"test.cpp").write <<~CPP
      #include <thorvg.h>

      using namespace tvg;

      int main()
      {
          Initializer::init(1);
          Initializer::term();
          return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-I#{include}/thorvg-1", "-L#{lib}", "-lthorvg-1"
    system "./test"
  end
end
