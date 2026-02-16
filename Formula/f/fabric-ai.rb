class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.406.tar.gz"
  sha256 "b770ae707231c88e69bf229020421da7178b0675e65779a63ca5991980a6aaed"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c6cdc2f5d3d9190371dcb69b71e67f0d3da34f37afba8ea477ec1155c31a825"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c6cdc2f5d3d9190371dcb69b71e67f0d3da34f37afba8ea477ec1155c31a825"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c6cdc2f5d3d9190371dcb69b71e67f0d3da34f37afba8ea477ec1155c31a825"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd006d584d0233f7b11fde98fbda29987148ed5f6d47336a0fe99ca04611ea7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "074ae4c3555d7d279b91fb01d89051eb0174abaf6cb67536f607b942282577d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df39002ee8e1ee19be8f0edc249f679f8ddcffc8b07a6d1e3697ca719aca54fb"
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
