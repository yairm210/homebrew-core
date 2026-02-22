class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "39fc00fc8998c8c6b735bb56e815ed6c4621acf6d4794bcaecf5f1c09ab764d9"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models found", shell_output("#{bin}/llmfit info llama")
  end
end
