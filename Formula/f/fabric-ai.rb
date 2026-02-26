class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.421.tar.gz"
  sha256 "7b83d6c4a97a4ea4bf1724cf87ef1bbdbadca43d155abb5e72a0ce5089598fcd"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63e08527b01e16d8ad1e608337c61663bb4e16634191818a26b0c67d8853cce1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63e08527b01e16d8ad1e608337c61663bb4e16634191818a26b0c67d8853cce1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63e08527b01e16d8ad1e608337c61663bb4e16634191818a26b0c67d8853cce1"
    sha256 cellar: :any_skip_relocation, sonoma:        "351cb99aa99b2389b82e351c4e08dd2157b6672580336e73ed84d8866f040c5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b4acf7443a173f2cff985552e11644f5b0d7e79739fd3dfe04280b9d101888c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aec72d476fabad9dda9c9d14501e08cf371ab949e2b39c54d8db67a031c65ab"
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
