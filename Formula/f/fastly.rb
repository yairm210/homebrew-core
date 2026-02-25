class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v14.0.0.tar.gz"
  sha256 "ae88c670c82b10a30ea134bc6dabc878478da49833bc710e208eebf32157e87f"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bde66f65c454828ffcf9286bf619bf7b936f83fa61746202268908611e315243"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bde66f65c454828ffcf9286bf619bf7b936f83fa61746202268908611e315243"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bde66f65c454828ffcf9286bf619bf7b936f83fa61746202268908611e315243"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec93282f64d2775a00d34e7d79a067785b1a1b9b834e03af8554909f595e357b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83a8349ed599d5e344ef326ddf6ee9ae9af148bc371b96a460ad6681eea8023e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a19af04f02d60420088da7becef66c5c6b68eafd283a6b584348f670f9603888"
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
