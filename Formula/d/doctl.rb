class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.151.0.tar.gz"
  sha256 "1319740897b7bd6d1bb5741668389d18b2aa06437cdf70f1a4fde40da356e81b"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "960616fc808899c5d85ceb44a4602f634efd7a0961f30693fbad2a734cb1ec7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "960616fc808899c5d85ceb44a4602f634efd7a0961f30693fbad2a734cb1ec7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "960616fc808899c5d85ceb44a4602f634efd7a0961f30693fbad2a734cb1ec7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "afb364a92499c66441087cae92d547fff7f54d4a271b789d9fa1d713ca410dcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a06cda92e85c4d300b856bb952a2a33c5dadd057fabc0b9337cf036c8e596bfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13caece961bcb280ced5057f207141e574ee4b67b4180238a4a282a0f72902cb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/digitalocean/doctl.Major=#{version.major}
      -X github.com/digitalocean/doctl.Minor=#{version.minor}
      -X github.com/digitalocean/doctl.Patch=#{version.patch}
      -X github.com/digitalocean/doctl.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
