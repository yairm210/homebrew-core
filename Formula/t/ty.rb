class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/66/c3/41ae6346443eedb65b96761abfab890a48ce2aa5a8a27af69c5c5d99064d/ty-0.0.17.tar.gz"
  sha256 "847ed6c120913e280bf9b54d8eaa7a1049708acb8824ad234e71498e8ad09f97"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e78c08d394600d3ea6ccb8abc63d2fb75fcd762a7e2646c67aa269ea29f499b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2740d853c54cf765e636fda44d93390d1dee8ad1bf1b3f8c047c19e6e938a5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17711ec9af45c6884e14e333b50c095a24d58afad83adde6d9145556a0a9780e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2267f79fb66ac190d67e0598aab24171faa6b76ded883b8bc6bc7d3e9217eabf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e5b039b90e60c3b95e4a1228db77860c17804d16d76650f273e6859f8ff0189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d86f7454445584fc04cbe66f6755c8464f52491675af58a9e1877f3dff5c76f"
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
