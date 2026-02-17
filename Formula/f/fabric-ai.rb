class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.409.tar.gz"
  sha256 "441bd5b865f973cc339a4914c80c35af533e7ebec1a5f4358c3ff2c98795d3e8"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6326e2d6f49f208bd4ecdc2f06e6a50a1070e3e75fe2c25045cfde7df517b483"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6326e2d6f49f208bd4ecdc2f06e6a50a1070e3e75fe2c25045cfde7df517b483"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6326e2d6f49f208bd4ecdc2f06e6a50a1070e3e75fe2c25045cfde7df517b483"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e2cff53d7f86bc20f3c8d43858ce4f2e43d95ee8f8b35ea31e0b8732a29c371"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f4adb7e981e190b7d6bcefb15165bbde793dd2b527548a3f7e6b09b8c40f6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6a3a73c0d21c909289330bec4a9bc0eb1a0f3b1a2a695ef62ff6554ae29c7a9"
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
