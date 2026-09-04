class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.108.3.tar.gz"
  sha256 "6b05121f1add5faa629d7850ef245e1d1667ed28612f4b9944173a796dbe52ac"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3be25c696467551cdd3d31815a66d43cf774d5814bc04ddced021e43094c4da6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3be25c696467551cdd3d31815a66d43cf774d5814bc04ddced021e43094c4da6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3be25c696467551cdd3d31815a66d43cf774d5814bc04ddced021e43094c4da6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bddc01d5c28426c8bb71b361bca0534dcb7c5b103273a9676e878bba72fba900"
    sha256 cellar: :any,                 x86_64_linux:  "e65e593b9cf5187a4971cc24f8732469a0af1a3d57e2ff3220d843d66e7c69fb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end
