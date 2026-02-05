class Gpac < Formula
  desc "Multimedia framework for research and academic purposes"
  homepage "https://gpac.io/"
  url "https://github.com/gpac/gpac/archive/refs/tags/v26.02.0.tar.gz"
  sha256 "7a265e1cd58b317d8c9175816a54e0ab14199c21d81eb779047d7088fca52ae4"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/gpac/gpac.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8bf0f70df5ff6eb637496a701d1edb87d1c0cba64d37727a0b901534a4bf0d25"
    sha256 cellar: :any,                 arm64_sequoia: "335e62cb07a553ba150f6af7f4908187c75df376fc51f1e8eb090fa40db1d3b0"
    sha256 cellar: :any,                 arm64_sonoma:  "f037bb51fc3e11634361c80b4a7ba00550fd1e7fb933cb12a940282bf3710a9f"
    sha256                               sonoma:        "62c598517a06e0e18a0704e6b1252cd4f3adb1aca18a32befc6001092c88d620"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11baac845e8aa3acfd9eb7cc026271bf87e93aa2041fe7b405d64b499634156c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6ade92b91ef193a6ff88d76a1f311a96785b203487e7d6f4f6a862497625f5d"
  end

  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libnghttp2"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "openjpeg"
  depends_on "openssl@3"
  depends_on "sdl2"
  depends_on "theora"
  depends_on "xz"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libxv"
    depends_on "pulseaudio"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"MP4Box", "-add", test_fixtures("test.mp3"), testpath/"mp4box.mp4"
    assert_path_exists testpath/"mp4box.mp4"

    system bin/"gpac", "-i", test_fixtures("test.mp3"), "-o", testpath/"gpac.mp4"
    assert_path_exists testpath/"gpac.mp4"

    assert_match "ft_font", shell_output("#{bin}/gpac -h modules")
  end
end
