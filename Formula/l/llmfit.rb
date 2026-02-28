class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "93e6f82c698e34f0b19562f74369d8b66c193110d6bf29fe113088c7d8f36110"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4c68b215e822bbd930a7a415acc7bbcd522c16eb4aca4f20ea0ff27c012f1c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf5355fb67165448bfc74e15552d42168e46a768627fe25399c4e97805030aca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69674ff9232ce090bff36e0b30a225ee93ca05e2d0949ea35216025f4e59f997"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e7b67917c6144fb2f61285fbdd9f63f9120dced72cb5b2a75a924ee408b2da9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "539de9fd7d039911f584e38b026f37e1c6a5aa2fab1325d2000fc474674b1f57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b7fe05cc7cde00de775ffa9ef9a17fd9f1478f60de53534c2940acc38144163"
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
