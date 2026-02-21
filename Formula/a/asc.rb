class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.31.2.tar.gz"
  sha256 "571f6fa01dee0f5f87c620936d3f5f914cd5aeb9edf7851d32d59e17c82bf4e1"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b23c1488b1ec2e1485d22e58f02eb8afdc3825d7fc569f1c00bdf51ba7134d99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "445ab9970275f35b177123461953ba1efcbda5e44d389061983146b198729eb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd3ebfda1427db6b4b6f4f4d9b084557cc0e8275eff88ca9007cace816f0a700"
    sha256 cellar: :any_skip_relocation, sonoma:        "feb846ed246337dfd016b2afeada390a4c2d3614df3d9c0dc958842255b227de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0430ab8f03002faf5afb2e2cac12e93cd8b2c3cc1c2a27291d5020318056ef8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4abc3cac5d949ca287bb55e1bfd4d4b6ac124ecc9dca4f53aae59b5675aaf7ae"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
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
