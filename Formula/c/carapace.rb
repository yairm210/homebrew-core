class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "226907d1df5a0ceabbf4ec511019cb46e4649f42642a1d1d9618a9768efb56ed"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc44a4334cc9bac27955be70f504bfd51f50f307d02b25a72ddd668d8a1cf2fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc44a4334cc9bac27955be70f504bfd51f50f307d02b25a72ddd668d8a1cf2fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc44a4334cc9bac27955be70f504bfd51f50f307d02b25a72ddd668d8a1cf2fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9b755099a1bd1cacc2ddc7847f78f9120b4ca3ece75d54561f9c41292f43a22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a52d260aff0ff3d268bcd42b8855ff0446d0d2ab481dffb1ea08ebb9c939f73c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19a91777a7a74522213b0dfa34df3e0a2e2a20efb3576d2e230f6a1859e172d0"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
