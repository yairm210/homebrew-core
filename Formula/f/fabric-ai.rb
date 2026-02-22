class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.419.tar.gz"
  sha256 "a855856a22bda88cd25cebf3cb547de560801d0ce336509ac3615254c110dae6"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4001d6f02d4add93d54154019398ce50d8cb27a7a2aef42d7ffbfee3af7a4c29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4001d6f02d4add93d54154019398ce50d8cb27a7a2aef42d7ffbfee3af7a4c29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4001d6f02d4add93d54154019398ce50d8cb27a7a2aef42d7ffbfee3af7a4c29"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa78fb8498d694a8fe71d2ff687988002f6a792e1c3bf68bd259368bfb63e78f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1d23606ea239f6f51cb887e3e90e004c5ee18061955bfc09fc8d7bee3ecd17d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a4558af380e677c9468bc876a8c680e7f70277d0726face7507e2c5f3952847"
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
