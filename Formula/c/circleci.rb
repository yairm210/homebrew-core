class Circleci < Formula
  desc "Enables you to reproduce the CircleCI environment locally"
  homepage "https://circleci.com/docs/guides/toolkit/local-cli/"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v0.1.34592",
      revision: "eb42c19acdf9551e2a9baf9a8cc98b962a28bd4c"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61df37189ac110f2473b8ce593975efd94c876cb6fc4b512a21bad681b2486f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7909101f0f0c36c2bb3d258cf512741a910fc81b451d3c5369edc2fb23532c21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50b148f8975c2fe328662c76b5f2099ce9afbf5869a8e8f777ed369a443fb62a"
    sha256 cellar: :any_skip_relocation, sonoma:        "91b505cbbb69b06c223622c6a77ce0736942cad52884170ed00f85af2790b8a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47eacdf7df369ab0c8e47a15354b65647985ae149de386a551966187061a2a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1fe45d6cd4747f3b1984ebc446a618785a5334ce1c630a11c8759c0993c7449"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/CircleCI-Public/circleci-cli/version.packageManager=#{tap.user.downcase}
      -X github.com/CircleCI-Public/circleci-cli/version.Version=#{version}
      -X github.com/CircleCI-Public/circleci-cli/version.Commit=#{Utils.git_short_head}
      -X github.com/CircleCI-Public/circleci-cli/telemetry.SegmentEndpoint=https://api.segment.io
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"circleci", "--skip-update-check", "completion",
                                        shells: [:bash, :zsh])
  end

  test do
    ENV["CIRCLECI_CLI_TELEMETRY_OPTOUT"] = "1"
    # assert basic script execution
    assert_match(/#{version}\+.{7}/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
    # assert update is not included in output of help meaning it was not included in the build
    assert_match(/update.+This command is unavailable on your platform/, shell_output("#{bin}/circleci help 2>&1"))
    assert_match "update is not available because this tool was installed using homebrew.",
      shell_output("#{bin}/circleci update")
  end
end
