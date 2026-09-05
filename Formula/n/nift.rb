class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://github.com/nift-dev/nift/archive/refs/tags/v4.0.10.tar.gz"
  sha256 "9c1c53931dfc1a770ddeba1b2f780cf4b7bf0c3189f48e0ed5e5e3f1eca3e5c9"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53f9c51e2bd8b29e76dff52ddf0624777702fce9340d6e585ac8f12a6c605843"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6217dbd511b3271191a6b9c9e187c69b5e327b204682fc5c4c8e84f5fdafdbb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b56efbd346aa992071fe79b69cea61e89fd9bcdd149ea50f04e30dbaa3cf71d8"
    sha256 cellar: :any,                 arm64_linux:   "7bb1f18d675a0f9c164998a6af5e1bd5afb1644efb5fde649f5dda7190713404"
    sha256 cellar: :any,                 x86_64_linux:  "a9c24bdbe27129a8fff5f661fa9bc7e5abf2df1c15d9f69bb1ab20f2627f740b"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"nift", "init", "--ext=.html"
    assert_path_exists testpath/"public/index.html"
  end
end
