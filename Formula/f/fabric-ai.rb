class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.409.tar.gz"
  sha256 "441bd5b865f973cc339a4914c80c35af533e7ebec1a5f4358c3ff2c98795d3e8"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26cc209e38c564d438aa7f29a5c06a08ecca1679fc773b18c260f5120d2922d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26cc209e38c564d438aa7f29a5c06a08ecca1679fc773b18c260f5120d2922d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26cc209e38c564d438aa7f29a5c06a08ecca1679fc773b18c260f5120d2922d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c958f8bc70062c3795cbf2ff98345683d7bf31792a658c64118a519b25a8c67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfbac32a9de1d24ade9d165ef555f5efb027dd9c5cca4aff86293864ca96a210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "998276288e4fc2d745e86b23cc00b5f313623098d328f402661b4a031f3f4dd0"
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
