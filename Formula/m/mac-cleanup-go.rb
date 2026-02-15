class MacCleanupGo < Formula
  desc "TUI macOS cleaner that scans caches/logs and lets you select what to delete"
  homepage "https://github.com/2ykwang/mac-cleanup-go"
  url "https://github.com/2ykwang/mac-cleanup-go/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "0b55bf2e415f1a458236fcb6cc624e1738f8f3c720fbde360c2ca43e84c4d54d"
  license "MIT"
  head "https://github.com/2ykwang/mac-cleanup-go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61888c95b54332a27fbaf6b85594e7f6cf7ee91eca474f43ed2cf79f35e07e64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61888c95b54332a27fbaf6b85594e7f6cf7ee91eca474f43ed2cf79f35e07e64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61888c95b54332a27fbaf6b85594e7f6cf7ee91eca474f43ed2cf79f35e07e64"
    sha256 cellar: :any_skip_relocation, sonoma:        "164c703018e0084fd8abe11a8002a357ce3ff7272019e85246b36ee739e4ed8f"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"mac-cleanup")
  end

  test do
    # mac-cleanup-go is a TUI application
    assert_match version.to_s, shell_output("#{bin}/mac-cleanup --version")
  end
end
