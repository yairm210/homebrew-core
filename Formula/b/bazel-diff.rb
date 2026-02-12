class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/13.0.0/bazel-diff_deploy.jar"
  sha256 "e0724edee9e421e027d34e9057b9fee723d4d5bed6c38d2c5010cb10263d6e69"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "08da291bbc23f0a940ddbd69920a9508a9e65f5f70450f3ae2d66a6706883eeb"
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
