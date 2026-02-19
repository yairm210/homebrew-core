class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/15.0.2/bazel-diff_deploy.jar"
  sha256 "3c05cff3fe26441d197aff69afbe2f35a5e0b1eaf608f715ae05dcce4c728297"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "46f53cbcc7d8db707412a7b86190f3b6bd60c7b3f8454f773a0e2798767f07b6"
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
