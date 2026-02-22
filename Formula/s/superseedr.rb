class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "03d47c6e37e00491ef263879f8023104f2f0025ec3cac8fbc0f887f853f4ad67"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d82fd67f992e7b730b47ec57e1b06d6ad5761e6a16fd71a0d88b8080e62a6bff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f57b7294ca794176b2f94fff3e3192cee04432b4a44b0c4efcef98ea0b6b359"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7dea454550a886a966ef7d93e5b85ce57f9b710d68071f2aed7d50c0ef1d801"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a7371e8064f103899fca6c2409c4a3f1a4091183d51ac3b85c9f6790d25c8bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94005d3a38bb7b223c67addeaa0fa4b3ffeb91d0e2ffac89208cc42d3dad4c1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1addfbc496f4d29065c328854cb4c8a78d2fc5ffb5b85a8e66dd95fb94bb7384"
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
