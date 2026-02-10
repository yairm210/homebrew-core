class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.44.0.tar.gz"
  sha256 "eddf7615d957bd6f538bc3867289a38858b66d3ef92808624c04151c37617732"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e892c8e4f497ceaed50a7abf77fd209d4900096afbdd25a9d4d39d1398428c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac27b9264162b9fb049676f8a0d5638128b1a98d4bff1c79a2b66822002ca27b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ecd0452ea27ec255d396ac4a4ccc63a47b9925e30d08f7d5aea0e0059684fe2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec1987f21827464ac46fef617b6cd27c756af78b8c07aade2d4e0ad60c759531"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2a3b24f7d9a09f18bb8fd9a3f99c3f0f4305c83bf482ceb9fe3092b5e069c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcf30efd1113c33ba8edb09f4b811ab5c97041755cb50aaacb2b1888c38e0967"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
