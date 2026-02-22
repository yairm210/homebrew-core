class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v1.7.9.tar.gz"
  sha256 "6c5357ba4ebe00cd35f1f05685e1983e4f7f808a6f041dbf91302dbbfc9805f3"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efbfb8ecf5c2740e49999bb69420aa7e8fd9df99bc02a0d9202903a655342ed0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efbfb8ecf5c2740e49999bb69420aa7e8fd9df99bc02a0d9202903a655342ed0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efbfb8ecf5c2740e49999bb69420aa7e8fd9df99bc02a0d9202903a655342ed0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e8a6bb80bf975fccee639e87fc03f9dd751481bf6f747fea03feab9e23ce6d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61556ab14572fbb0297aa92fe9bf6045e28fd369c65598f18211b42127e19a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46b2f5f6a6e21fd5770ff3662f8d2f794ff7f8b30f6bc2ae527df8696d8cae87"
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
