class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "e2b78bdad1642095f301d8921a06fd1194966d7f637dcad4ef8bd44d20c65d7d"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1e7ee994e2a6a61595abe2b90cefab77b9af5478bbb1748aaa3252f5aa856e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1e7ee994e2a6a61595abe2b90cefab77b9af5478bbb1748aaa3252f5aa856e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1e7ee994e2a6a61595abe2b90cefab77b9af5478bbb1748aaa3252f5aa856e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "04cea1d3704b70edf9d182e5a9086cc26f642720476378dd0eec8656adf3df83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "443547d811a465d0af9f2825b9146f5def4d2cdd214e9fdead3e3f9496922135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "514413f71fa999f1587fa86a597dc1aae685ca19062cde87caa6a979e980109d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kriuchkov/tock/internal/adapters/cli.version=#{version}
      -X github.com/kriuchkov/tock/internal/adapters/cli.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/adapters/cli.date=#{Date.today}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end
