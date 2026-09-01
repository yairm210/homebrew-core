class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/98/82/d840488d9e2e30ce5d7b11324bb79bb15e040a2ebd6b0f28fc4376ec0dc8/ty-0.0.76.tar.gz"
  sha256 "26029f10116db099896be693b316ba972dcbec00c115caafb646fd7c00dbdd37"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a397e34a385107710669d7e48b899669b1f06feae9f5226864d586fd03de491"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2e90d6c2ab3b9179ff87540e8b0a62d71e41d87f82c44f69f9249bdc92e6171"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce620a7d909e1f0cc06bd17c3522fe9c00d460ed18e1699c15b06feee1a9389f"
    sha256 cellar: :any,                 arm64_linux:   "401d6d3339e5b0a8a8945d54ed3d4b31650b524b97f677cf2e120691362ba4be"
    sha256 cellar: :any,                 x86_64_linux:  "3c496c2798a9a6a8528ac2b3f091dc3019d0abc1f8301e7c4afc317c8654644d"
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
