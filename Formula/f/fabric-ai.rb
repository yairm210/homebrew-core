class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.422.tar.gz"
  sha256 "0eb22dab4879133b011f5adb3570e3fa7d6c7fc5c2d848036fdc206581a6cb87"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f15801ce3a5c23eb84e196a9b268537dca196113a9c7c41b03d397e08ee1303"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f15801ce3a5c23eb84e196a9b268537dca196113a9c7c41b03d397e08ee1303"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f15801ce3a5c23eb84e196a9b268537dca196113a9c7c41b03d397e08ee1303"
    sha256 cellar: :any_skip_relocation, sonoma:        "509a03e7fa731718fc87829969ead20606c12751729d46676c45b246546dd244"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e34250817cd46f0cb03fe377fae108d4023440a2f830d8a21f8266f070943dd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61042cb28544d5a890f3159cf107c0c5b6cceab69540ada892c9f547b7b1bfc5"
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
