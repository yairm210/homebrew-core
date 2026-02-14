class MacCleanupGo < Formula
  desc "TUI macOS cleaner that scans caches/logs and lets you select what to delete"
  homepage "https://github.com/2ykwang/mac-cleanup-go"
  url "https://github.com/2ykwang/mac-cleanup-go/archive/refs/tags/v1.3.12.tar.gz"
  sha256 "ec1399169c968f476eeb8014faa075f015bd320edfef8d982f8c700afd019eb6"
  license "MIT"
  head "https://github.com/2ykwang/mac-cleanup-go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3af9fb2d2c9c679179c127ad0b0a8b9f16f15761a0aa31f47aa405e18fdbe5ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3af9fb2d2c9c679179c127ad0b0a8b9f16f15761a0aa31f47aa405e18fdbe5ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3af9fb2d2c9c679179c127ad0b0a8b9f16f15761a0aa31f47aa405e18fdbe5ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "4936a4f85a91e221874d83f001d4f35d2301f96e1b3ea0dfa07614ee22ee12fe"
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
