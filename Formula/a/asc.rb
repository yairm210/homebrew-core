class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/6.2.0.tar.gz"
  sha256 "cfcc6fd94521a54218185613baff232073415a0533da40858bea8d0c621dac06"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "878c1f2f37d8cf51b8bda6f0c879e7a818969468b76a6b99fb7adfda2315656d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8bde54e0a835f493f6c9ba10378c799bf608b5d3250dc7895e9ea5ec6a24985a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3b43df38461faae0da316e972e993527db38e358330fe8b258abdedcad9f05bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2faebcdd73977a9b3b7af1f84506aad0c9606c75a576b1e2e26130129b820751"
    sha256 cellar: :any,                 x86_64_linux:      "9dc09433b393a470963bfc5ae6108a00b4f4c9f9fd7ce3349253a8f883d579d9"
  end

  depends_on "go" => :build

  conflicts_with "asccli", because: "both install `asc` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
