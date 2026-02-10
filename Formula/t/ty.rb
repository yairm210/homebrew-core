class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/ee/18/77f84d89db54ea0d1d1b09fa2f630ac4c240c8e270761cb908c06b6e735c/ty-0.0.16.tar.gz"
  sha256 "a999b0db6aed7d6294d036ebe43301105681e0c821a19989be7c145805d7351c"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "158253d6b51b31bd029042109cc664b49676a4d30ddfd8113b1048d328fe55d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e8babf247c872570ac182eb8333ffd02cb16113cf4f56d6886f7fc9ceafa92f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13ef3bc99dd4a302afba048f4fe4afe8e8b26157a68b6572a82d50cd48d033ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "72eb0ddcff8ada52c8071023b62fd71a0f668d7880d6359de4089b2b1b4857d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1c8178552b7d086d9a1dfd1f1beb23fdd99234421c306a5b3dca56b90997111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "280d5e92a001eefb56c3e892b4e1af52d6351503a1d7f74c5894534d18012cb3"
  end

  depends_on "rust" => :build

  def install
    ENV["TY_COMMIT_SHORT_HASH"] = tap.user
    # Not using `time` since SOURCE_DATE_EPOCH is set to 2006
    ENV["TY_COMMIT_DATE"] = Time.now.utc.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "ruff/crates/ty")
    generate_completions_from_executable(bin/"ty", "generate-shell-completion")
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PY
      def f(x: int) -> str:
          return x
    PY

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end
