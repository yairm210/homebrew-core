class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "4791924f593cab7a9af2796c57ffe28eb7b2fa71cf6c13453ed1197a82d5301c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6a402f2e4a538f233a49b2f7e8752875609b8b8f238a0b48d86b30664e0d598"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6a402f2e4a538f233a49b2f7e8752875609b8b8f238a0b48d86b30664e0d598"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6a402f2e4a538f233a49b2f7e8752875609b8b8f238a0b48d86b30664e0d598"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d2a378cb8a83efc2a3d7b3c32648534b0ece26dfbf8d10e9ab1c4d06e5ea744"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89b14d2b83fc997b8f72e6a2b95853de950d05c409b9b928fdac72cd11c222d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9d4a5ab7ddb89e2a76ed047229728f9b5d4e7d164463aa9d337197de93ab237"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Dicklesworthstone/beads_viewer/pkg/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"bv"), "./cmd/bv"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/bv --version")

    # Test that it detects missing .beads directory.
    output = shell_output("#{bin}/bv --robot-insights 2>&1", 1)
    assert_match "failed to read beads directory", output
  end
end
