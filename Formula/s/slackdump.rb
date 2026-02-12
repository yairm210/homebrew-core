class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "8af0513f50276aafa4abbe3d76949ef56d27bd6256b499361f536e2a8c7d1212"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0f14e107668df41d09d01669d52c7a0f2fa349a8492575e4fb563788c31ad95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0f14e107668df41d09d01669d52c7a0f2fa349a8492575e4fb563788c31ad95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0f14e107668df41d09d01669d52c7a0f2fa349a8492575e4fb563788c31ad95"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac0bfe054630433899876c50d3972803d8fdf8b54e0e6c4cac21d5888063b86f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52e8f8aea40c09bbcc302afc14c35bca2242e2ba6a4f7cabfe99f00a425d211c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a979a6bcd835748b24a121a9dd9a2fb245fbaeec44ad7c6be041b78fb22c784a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackdump version")

    output = shell_output("#{bin}/slackdump workspace list 2>&1", 9)
    assert_match "(User Error): no authenticated workspaces", output
  end
end
