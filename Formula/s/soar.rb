class Soar < Formula
  desc "Fast, modern package manager for Static Binaries, Portable Formats and more"
  homepage "https://soar.qaidvoid.dev"
  url "https://github.com/pkgforge/soar/archive/refs/tags/v0.13.4.tar.gz"
  sha256 "571b4735fa0c9d612ad4b3a3a34dc80047cb7b4d14f69c49607e3508d6ed5582"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "56f677e23e30fa2fbd41020a8e0b3057a4ff32b327109fb078e01f21efd3b8f9"
    sha256 cellar: :any, x86_64_linux: "28d72ad946450721cd8fbba60e5ba8d27ae620ba45bc5918d3a9460810847f94"
  end

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/soar-cli")
  end

  test do
    system bin/"soar", "defconfig", "-c", "test.toml"
    assert_match 'default_profile = "default"', shell_output("cat test.toml")
  end
end
