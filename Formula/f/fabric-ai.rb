class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.416.tar.gz"
  sha256 "1ace3defe6944715ac4d6955ea0aff06d9353c82488e7973f9b7827af6ca3de2"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c502d7a26cd5e65c54dbec00e8492df694b209b0a56188b7767e91ccd14f495"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c502d7a26cd5e65c54dbec00e8492df694b209b0a56188b7767e91ccd14f495"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c502d7a26cd5e65c54dbec00e8492df694b209b0a56188b7767e91ccd14f495"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e03304b5c7343c87604eeff2122a1e5cfd26ada3fd7169b94e73356a2a79e13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b607624c1721df95e624f0a1d2e3a5fad82a022d4c94bd2f4514f618e64eae66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6008637dac8a9a15c7b05656892877897a063b81e65e76c159408e0d9498699b"
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
