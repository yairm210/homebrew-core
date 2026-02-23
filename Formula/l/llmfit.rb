class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "d7513df43dd496f07472dcfce1a20bf55bbcfd357b12653f2cd1ca973a94f14d"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17553a6e818f43fd678f6c5ecb709ee5f26e3caa59873a5130f98299198e2540"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d6c60cb961f45d24ec9142e87a1a421f3b88efdf66953d24af0ba261c88754f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff8c57b18b6e60b38ca919207053fad229734068a87d76762e941a23c9113c67"
    sha256 cellar: :any_skip_relocation, sonoma:        "690eaffcbb403007a0fde42e57f7c5021498aba510a87163de06a13470c49faa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d967cafe6b5cf80841c9756b6722c0f0f35d04f2ce64ee4d991693f0eb6cbc05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b74e86e1f9e6c883521d045fc60c6dd074f15fcc25a4a603a0c907adfec26f59"
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
