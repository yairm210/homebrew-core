class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "2122507bfbbb8acf71de7d52419bc971381390fd04e732e54a366b28b96587da"
  license "Apache-2.0"
  head "https://github.com/liqotech/liqo.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0a7564fdf3668b894ceaa9a66468dab81fcda94233d72aadc3608e1ba4e7314"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0a7564fdf3668b894ceaa9a66468dab81fcda94233d72aadc3608e1ba4e7314"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0a7564fdf3668b894ceaa9a66468dab81fcda94233d72aadc3608e1ba4e7314"
    sha256 cellar: :any_skip_relocation, sonoma:        "c55a6eeecb3a7f936f007106e8cd633ea61796eb2c21cc1292a30f3b355dce2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "232af48c5b9752029d5c72a83d1e246b05d075b0a3595c553a7e8aaa7624ae0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eedfa6b953b322000d5b6c673c755149c6cc8de0d82a3489da65e46591e7103"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.LiqoctlVersion=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/liqoctl"

    generate_completions_from_executable(bin/"liqoctl", shell_parameter_format: :cobra)
  end

  test do
    run_output = shell_output("#{bin}/liqoctl 2>&1")
    assert_match "liqoctl is a CLI tool to install and manage Liqo.", run_output
    assert_match version.to_s, shell_output("#{bin}/liqoctl version --client")
  end
end
