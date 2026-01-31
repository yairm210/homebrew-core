class Scummvm < Formula
  desc "Graphic adventure game interpreter"
  homepage "https://www.scummvm.org/"
  url "https://downloads.scummvm.org/frs/scummvm/2026.1.0/scummvm-2026.1.0.tar.xz"
  sha256 "e15b8650c2bd9e11b69b49eef9dea1eedccc5b1c191748b15c34167614d77b66"
  license "GPL-3.0-or-later"
  head "https://github.com/scummvm/scummvm.git", branch: "master"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1e1518b840350265526bab90fbd3469a669052a3598ade2dbfa2907c8806b978"
    sha256 arm64_sequoia: "af1a4656f89211d7be7b493ac7ad5db142b318058121c48f73f592272f019a22"
    sha256 arm64_sonoma:  "e5314b9eec38aaa5556d5481530573080028ad62a2bb54cd2a9e033fe290b876"
    sha256 arm64_ventura: "2c09fab2039ad292c9d2f1e2dd0f21c02fcfa7df5340037057d43a7814aeda56"
    sha256 sonoma:        "1bac1262b8f2dad18d22f2d2a0d08f7090e6f4579c989bb104a636d8d6b6b0c0"
    sha256 ventura:       "2d10a2dfb6d2482ed25a3e2ffdc8d20ac59dcf7cf6bd0d1ca977b61a71169c6f"
    sha256 arm64_linux:   "9e66e94115cd793f5cce20420a2223fa7c38e82400bedb31f1c7b50787c7dc15"
    sha256 x86_64_linux:  "3d608c81d285a7b766260af1e646749bbf98ad8a977e140dbda9de012aaf5d6b"
  end

  depends_on "a52dec"
  depends_on "faad2"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libmpeg2"
  depends_on "libogg"
  depends_on "libopenmpt"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "mad"
  depends_on "sdl2"
  depends_on "theora"

  uses_from_macos "zlib"

  on_macos do
    depends_on "musepack"
  end

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "./configure", "--enable-release", "--with-sdl-prefix=#{Formula["sdl2"].opt_prefix}", *std_configure_args
    system "make", "install"

    rm_r(share/"pixmaps")
    rm_r(share/"icons")
  end

  test do
    # Use dummy driver to avoid issues with headless CI
    ENV["SDL_VIDEODRIVER"] = "dummy"
    ENV["SDL_AUDIODRIVER"] = "dummy"
    system bin/"scummvm", "-v"
  end
end
