class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.97.2.tar.gz"
  sha256 "38a25b3b59350fca55c029379704ca2ce8ad21a43b0c038b1b3f3f24db0a5ec5"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfe5e0518a86e2afb1240d7d6f24034d86d9f4019a0df88a40386620fd64b6c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffd1d588d66de0de5bd44e0e48896883605e6ae6ab7af5f3d688892efbcba135"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19b6fb8c6732b09b5bf04537cd0c3758c8a87bd3065a3587d050057b61b8bf5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1875dbeb47b2986b231338b32c7fdfda02d9e358f6abbd2c0547f485bae0a0a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56ae057a0af49ba519176f7b50e0dc5cd3dc0d3627af58e6602fdf1c6e4e2cfa"
    sha256 cellar: :any,                 x86_64_linux:  "6728984f5cc471c58d50bd4758fa95198988dd57216ed79de00b04f20bf4726f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "docs/man/trufflehog.1"
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
