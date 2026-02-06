class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "658243c7c649ac035ad522cacdeb699783e562488d728e421119f71a5494c325"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de2e3b5d332c6442bd577e8ba3db0622dc97c7e30ac23ab802de88535579fe9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3febcb92aa3cdb1e6b2698f9568599f53888d90c07720391ab2f3dad37a3766b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac409b3dd52e072bde89332b008f0adce48585e6d43236b4fba1e0e558888e87"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1961ac81213d3d85a8418704465bdb1295508a9030f0c72498f97ac49fc8238"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5974de3d1d357b0738848b3cd1fb60177c71848eebe5917e431fa383b1f38d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a80cde1310e9086cb2fc8588cdeae4be62ec6c33f82b8b69a06999698acd98c8"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    output = shell_output("#{bin}/goose info")
    assert_match "Paths:", output
    assert_match "Config dir:", output
    assert_match "Sessions DB (sqlite):", output
  end
end
