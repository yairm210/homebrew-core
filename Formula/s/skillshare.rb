class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "b66553cab5c88721023125bbaa8d77bd83dd28d3d4cd4ec563cc985d142fa0d6"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd80eb1737a1d0fb6f07108238247c1354df09e8a360f2ac02a2a0a73f77c18a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd80eb1737a1d0fb6f07108238247c1354df09e8a360f2ac02a2a0a73f77c18a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd80eb1737a1d0fb6f07108238247c1354df09e8a360f2ac02a2a0a73f77c18a"
    sha256 cellar: :any_skip_relocation, sonoma:        "17e18b977e937f31311d3572ebf3e0b701ccbffedf31dab2251c9d095c9cc345"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddd6450543ee69036b1988d3e67db4ad9dfdb85e6e073af1285b961ad2b03072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5dc3eef29e004fa2d2763afb0bb702f5a13bf6cc2f2849113c66b57c97cc788"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
