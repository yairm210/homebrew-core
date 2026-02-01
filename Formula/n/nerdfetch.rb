class Nerdfetch < Formula
  desc "POSIX *nix fetch script using Nerdfonts"
  homepage "https://github.com/ThatOneCalculator/NerdFetch"
  url "https://github.com/ThatOneCalculator/NerdFetch/archive/refs/tags/v8.5.0.tar.gz"
  sha256 "c2fb7e7fc33690a69b7beaf6473d56c882a44ba3bbe63150f45a97f107220741"
  license "MIT"
  head "https://github.com/ThatOneCalculator/NerdFetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e441ddc3a3129b74f1b924c3740411667addf14ee01339d2d38f63fb1e4b25a0"
  end

  def install
    bin.install "nerdfetch"
  end

  test do
    user = ENV["USER"]
    assert_match user.to_s, shell_output(bin/"nerdfetch")
  end
end
