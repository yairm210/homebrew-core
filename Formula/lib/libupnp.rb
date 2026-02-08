class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.28/libupnp-1.14.28.tar.bz2"
  sha256 "5928520ab205a38c383b9e2d4d89db4642f127b5ce54e6af4f038bdfb09befa7"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cbffacac8c2a50e4cba8c6508597173b82b19b4113d814b6db2a263dcb7cc345"
    sha256 cellar: :any,                 arm64_sequoia: "1244a805dd19fcf2fc9534291ce651a45ecbc12606f4973c94c17df401b3cb72"
    sha256 cellar: :any,                 arm64_sonoma:  "c7759e14260d88ca34b72bddbe31287ff678cbe0a6b719f2293a1d424259c3be"
    sha256 cellar: :any,                 sonoma:        "7f4184f9d0fe65f44c2d081c264eef876d95ee9eb775dd48e2a46b1825972ce2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b5d75bebd0ce69a078b5cabbff3c5e8b6d689dd98e555bbb57d39697dd011b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3c58d6000ad8a4617f3d5204f3f0f6305ef9780276dee344b2a185417e1fcf5"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ipv6
    ]

    system "./configure", *args
    system "make", "install"
  end
end
