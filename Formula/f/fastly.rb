class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v14.0.4.tar.gz"
  sha256 "25a203f89075031da408e94b1d272909ea2cd5ed72b78936fc7b7ba0f06d8976"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba22821ad73cef2e93e1973806d3a6ee43a0b72985fed664e90bd3f3cfeb5711"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba22821ad73cef2e93e1973806d3a6ee43a0b72985fed664e90bd3f3cfeb5711"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba22821ad73cef2e93e1973806d3a6ee43a0b72985fed664e90bd3f3cfeb5711"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2eb9ecbc4dbc29c73e80cc757b76753d065c509eee1347883fca323d43ae8cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85616eed33de0c1b83e0e6ed762946405d216a227aa6a4d7242266d2e11e9256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66afa16b11007c3e7df2dc773159451ecc19732d64ab6726bbd0abf21b0bf3f6"
  end

  depends_on "go" => :build

  def install
    mv ".fastly/config.toml", "pkg/config/config.toml"

    os = Utils.safe_popen_read("go", "env", "GOOS").strip
    arch = Utils.safe_popen_read("go", "env", "GOARCH").strip

    ldflags = %W[
      -s -w
      -X github.com/fastly/cli/pkg/revision.AppVersion=v#{version}
      -X github.com/fastly/cli/pkg/revision.GitCommit=#{tap.user}
      -X github.com/fastly/cli/pkg/revision.GoHostOS=#{os}
      -X github.com/fastly/cli/pkg/revision.GoHostArch=#{arch}
      -X github.com/fastly/cli/pkg/revision.Environment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/fastly"

    generate_completions_from_executable(bin/"fastly", shell_parameter_format: "--completion-script-",
                                                       shells:                 [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fastly version")

    output = shell_output("#{bin}/fastly service list 2>&1", 1)
    assert_match "Fastly API returned 401 Unauthorized", output
  end
end
