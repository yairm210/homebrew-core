class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://watchexec.github.io/"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "b28761a8c51009c072a24155478e41efa3625ac9d6f1296d30e4945c9afc4042"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c73c29a74ecf909814d53de845863c7fa102db6e736ff207f2a26ed9736e508"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6db8c941eb8076cfaa14d893e9e7e0b5d404bb9da6218662ac97366b50947d9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b700ecdf3b37169fe2e1a7ee9a50a677b15a566a6dceb468ea20723ede516e99"
    sha256 cellar: :any_skip_relocation, sonoma:        "df891b11d3aa5a337913ba52fc5c3693d958800fdc0e37d79517f58caaeae547"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0d27f62deb7f4c14c6ec6ebd68be7a244c0baaa2738ac1f22da56dd91766a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "667eec66c7abba7ae185b33568304868ace335f88bc554a5973244b4a7faf6e0"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"watchexec", "--completions")
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read

    assert_match version.to_s, shell_output("#{bin}/watchexec --version")
  end
end
