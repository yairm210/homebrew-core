class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v0.9.39.tar.gz"
  sha256 "c5b0aace7bf24952aba1e4f635ba8c64d28423c5e87b51e88a73d7ca237f33e2"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f7d552dbcb113e935ad2073eedcdcc1b4168b3c4f8362c8feed9e912f1f3a62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccd065aa7f0b06a5d63d5c5c524958fbd161eea9b3428011208bc4121f15783e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "346b51e689379ac88b8bbab4543946591cb6d255ebbfaa13b80cb8f98181a1c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b523a3e9141272789de65436c1250a63a1c9161b18e63b494772cc46946247b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96b587b9937337609e60301730705eb9f5c7b6745e05d20aa35b8ac307a91214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b915452ddf8c942e1edd3072f6841dbebd4ce250cdeaa85ea281e9bd6204835"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # superseedr is a TUI application
    assert_match version.to_s, shell_output("#{bin}/superseedr --version")
  end
end
