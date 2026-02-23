class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "6067e71bdee6953a7031775aa4fe9342bc5db0b974c413cdcefda37f39a3a2a3"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9b2516d6e62d77b51308f27f450d6b3ac368a026e722d2be71bb93229db93c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9589904f0c3fe6b21cae067a29a441084dd963bd2b1e9c4b764a3f8d55f334fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "656d05294502ab00745c5d7e44332679e5a91ab31f61aa9205d25a7f3698d84b"
    sha256 cellar: :any_skip_relocation, sonoma:        "50bb922ef323026728d819f058823a340e83f77b1d853961d9d2f5dbd1ef3917"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "036bed671fb19a9483dbddf0b3008ea554e9ff7a891212a2dd1598f575794cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "494c047a93997b3666f611d6de59cc3fe14f85c2797d13d07f5f9bf4aeb7e436"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "llmfit-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models found", shell_output("#{bin}/llmfit info llama")
  end
end
