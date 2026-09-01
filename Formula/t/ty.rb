class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/98/82/d840488d9e2e30ce5d7b11324bb79bb15e040a2ebd6b0f28fc4376ec0dc8/ty-0.0.76.tar.gz"
  sha256 "26029f10116db099896be693b316ba972dcbec00c115caafb646fd7c00dbdd37"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ec1d10a086f6fac25e4bbcf84a1ea9616165aedd360b14ce750c414cbd218bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c675aea3eaf323d5e36150e3c0d18a73ac5722943f80c3a6897bf619f0e742e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6f5e0acf95a4f718833cb7d9c87af7c63229d307155f61d87d98f5ccf7ffe93"
    sha256 cellar: :any,                 arm64_linux:   "83cc4c1cf6a94f5766f4576e9ada72b8e389bfccf19d2a1ad88d962b5f792bb5"
    sha256 cellar: :any,                 x86_64_linux:  "78c86807b6ef96e2f9102e9fd2004d660043b38824853a23f85c6080c448c3f8"
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
