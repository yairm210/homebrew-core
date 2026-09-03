class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/d8/c7/2ba0861384c5b5097ac354383abb98188112cb330208c21d5197e98a29e5/ty-0.0.78.tar.gz"
  sha256 "770b45854f85fa11595208f08c0f28df80943164d10a2832d86be6ac29f135b2"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "573a700b93902b82443140203d0b398bf69ded7e025afec661776d01108d91c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aff2dc045d31ae1a80e071862a1bd48f4ff28f5cd2b13c89be9098d5ca5a919e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fb1d3cf972a6aca161cea240146e697d3a84c1c41dab08799e6b03d1915752d"
    sha256 cellar: :any,                 arm64_linux:   "a5c0980392819cb21f14e4d83c550c91383ff3f5a3c69514e57e4c98f8974892"
    sha256 cellar: :any,                 x86_64_linux:  "0c9d6775503e2a48660bdd29169942c24fb05bf440546b5038aab2f39fddba53"
  end

  depends_on "rust" => :build

  def install
    ENV["TY_COMMIT_SHORT_HASH"] = tap.user
    ENV["TY_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "ruff/crates/ty")
    generate_completions_from_executable(bin/"ty", "generate-shell-completion")
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PYTHON
      def f(x: int) -> str:
          return x
    PYTHON

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end
