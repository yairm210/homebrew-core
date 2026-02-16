class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.407.tar.gz"
  sha256 "4f014c053ac3342a86a88713c987835da76a88403b987bf704bbc537ae39deb2"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1197fd8ba1e5a3193ed630fbc78953cec2b0d09561f8dfd16aa47c8f8fd7b823"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1197fd8ba1e5a3193ed630fbc78953cec2b0d09561f8dfd16aa47c8f8fd7b823"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1197fd8ba1e5a3193ed630fbc78953cec2b0d09561f8dfd16aa47c8f8fd7b823"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bb02d99f3a85c3f11ff80418f27f0fe58960c178138d8e5465362dfc5e4017c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "518b24277b979f41382ca295c7b16598138e0611d28b3a8b0ad0bca6b5380883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee8945615d965aaf35098f8114fa144cfbb3d6478db73dd694831e22566fd736"
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
