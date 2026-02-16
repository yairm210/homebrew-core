class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/13.1.1/bazel-diff_deploy.jar"
  sha256 "f318a13fb62acfc05e3ab0a81a4c3036fc4c67509ebfce2faef3b793e79f9875"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2fcc33aafe50495458f0943bbe6d63cde3eeeb44dd9ff5d32b2d41c1fcf0780f"
  end

  depends_on "bazel" => :test
  depends_on "openjdk"

  def install
    libexec.install "bazel-diff_deploy.jar"
    bin.write_jar_script libexec/"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}/bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "ERROR: The 'info' command is only supported from within a workspace", output
  end
end
