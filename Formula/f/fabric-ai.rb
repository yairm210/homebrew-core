class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.411.tar.gz"
  sha256 "73e8b2b1110450a8297a619094f5480cd547864c8ca84471b6074fe80872864c"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02dcf211cb510747bb12ebcf3100006fc0538cc92ce6716031cff37438e2dce2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02dcf211cb510747bb12ebcf3100006fc0538cc92ce6716031cff37438e2dce2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02dcf211cb510747bb12ebcf3100006fc0538cc92ce6716031cff37438e2dce2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d64fdd883c3bd943a7c953584acb7126cd70a828f6ca022c26cac5cfe0523640"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efb015bcc1ec62e5ed4457b71282c38f3c7de357bbf3f9847fead5cffbe2a7d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caa8b7551a27c82320892aab130f5b4d1b50280be613e62ea0eb62dced13daf6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
