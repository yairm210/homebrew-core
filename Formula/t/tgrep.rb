class Tgrep < Formula
  desc "Trigram-indexed grep for fast regex search in large codebases"
  homepage "https://github.com/microsoft/tgrep"
  url "https://github.com/microsoft/tgrep/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "d91fc2f4cd04998a16b92cf58d29bfc94272fff39a78701b32223a05e1e89b68"
  license "MIT"
  head "https://github.com/microsoft/tgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f28fe8f25aab52e04f9f390c0e00926f9e18c26c6a536260122e89d4bddfd9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d0c52f4ff0754aad894a747324ba186a5f1db8d55d62d0be6a7300fb59be7f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46d78ff20eaec32e727e3c2a6d0c5c274425a63248e18c347eddcce12e4c9e79"
    sha256 cellar: :any,                 arm64_linux:   "d1d57fc2ec7c366931ae8606a8d4f8c05c3d9f03d9c402206fc34eebeb661825"
    sha256 cellar: :any,                 x86_64_linux:  "01a4d6ddc6640415687dbc8234ca1b911d6287dcd9df14927ff735c789e5023d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "tgrep-cli")
  end

  test do
    (testpath/"src").mkpath
    (testpath/"src/main.rs").write <<~RUST
      fn main() {
          println!("hello trigram");
      }
    RUST
    (testpath/"src/lib.rs").write <<~RUST
      pub fn helper() -> u32 { 42 }
    RUST
    (testpath/"notes.txt").write "nothing to see here\n"

    system bin/"tgrep", "index", testpath

    matches = shell_output("#{bin}/tgrep 'hello trigram' #{testpath}")
    assert_match "src/main.rs", matches
    assert_match "hello trigram", matches

    assert_match version.to_s, shell_output("#{bin}/tgrep --version")
  end
end
