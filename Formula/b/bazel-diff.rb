class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/15.0.4/release.tar.gz"
  sha256 "3dcbf162e9d287378edfcbf5f0008cd3f0f1bbe709aa3729f0d23c4601bc070f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f6763240dd786df11a84dba13e082364779cf1866482532b816b69c170ec932"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f6763240dd786df11a84dba13e082364779cf1866482532b816b69c170ec932"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f6763240dd786df11a84dba13e082364779cf1866482532b816b69c170ec932"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ec449d83bbd1bdc4bfc19120da1321a38e356b77ab23d7527821610e9b8a736"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44f3e5cba3116bb7bbcff28efda1e418b5fd74bccf6390553424ec35c17245c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7492bf4c58ffc72a5ab4595b7ffdedbb40f207e5b6a3070d0a3e2f38dfc20560"
  end

  depends_on "bazel" => [:build, :test]
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    rm ".bazelversion"

    extra_bazel_args = %w[
      -c opt
      --@protobuf//bazel/toolchains:prefer_prebuilt_protoc
      --enable_bzlmod
      --java_runtime_version=local_jdk
      --tool_java_runtime_version=local_jdk
      --repo_contents_cache=
    ]

    system "bazel", "build", *extra_bazel_args, "//cli:bazel-diff_deploy.jar"

    libexec.install "bazel-bin/cli/bazel-diff_deploy.jar"
    bin.write_jar_script libexec/"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}/bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "ERROR: The 'info' command is only supported from within a workspace", output
  end
end
