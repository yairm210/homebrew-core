class SoxNg < Formula
  desc "Sound eXchange NG"
  homepage "https://codeberg.org/sox_ng/sox_ng"
  url "https://codeberg.org/sox_ng/sox_ng/releases/download/sox_ng-14.7.0.9/sox_ng-14.7.0.9.tar.gz"
  sha256 "e69be36f0c843d7f7f21c0abb6526d4c71c348868eddc014be346ffbb7cd683c"
  license "GPL-2.0-only"
  head "https://codeberg.org/sox_ng/sox_ng.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sox_ng[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "03a6873f41102ccfdf0a04c998e2384f4b756f1be1517f69d9bdd601d985e2aa"
    sha256 cellar: :any,                 arm64_sequoia: "b5e0a278409182cf4ff8de041a5d00914c32e8ffcb1f28c7f216a683a5cc5884"
    sha256 cellar: :any,                 arm64_sonoma:  "778a6d4fdb81608f7710e0d283d3f2b1fc2c9a459d8875c54f347efc82a85053"
    sha256 cellar: :any,                 sonoma:        "3c82fac5acc923ee13578d7dec85dd08ae8820c0f285e7536f237a470c46282c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4ef8025d0321c09aadbe02db0465deb2b0bb04f4d217415c3a54e485c84d818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bbc27546d31502fe55f14288819f87fe18b57999ede568f1cf3bffb2a8a6e2b"
  end

  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "opusfile"
  depends_on "wavpack"

  on_macos do
    depends_on "opus"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "sox", because: "both install `play`, `rec`, `sox`, `soxi` binaries"

  def install
    args = %w[--enable-replace]
    args << "--with-alsa" if OS.linux?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    input = testpath/"test.wav"
    output = testpath/"concatenated.wav"
    cp test_fixtures("test.wav"), input
    system bin/"sox", input, input, output
    assert_path_exists output
  end
end
