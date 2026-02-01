class MacCleanupGo < Formula
  desc "TUI macOS cleaner that scans caches/logs and lets you select what to delete"
  homepage "https://github.com/2ykwang/mac-cleanup-go"
  url "https://github.com/2ykwang/mac-cleanup-go/archive/refs/tags/v1.3.9.tar.gz"
  sha256 "77ec93afa5136f97b62777971634f0199b4a5db789ddd83ece45d2c6e5892d8f"
  license "MIT"
  head "https://github.com/2ykwang/mac-cleanup-go.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7837067f48e3e574181ea8c2ca1b72427ad5e120d31493fa0dd0e794f17e6d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7837067f48e3e574181ea8c2ca1b72427ad5e120d31493fa0dd0e794f17e6d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7837067f48e3e574181ea8c2ca1b72427ad5e120d31493fa0dd0e794f17e6d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "93afa2bc043b692cca63a680f31d5226dbe2f8314bf48d8b653a54d4e6ab5405"
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
