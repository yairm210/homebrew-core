class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.654.tar.gz"
  sha256 "db1233ba5f11ecb12f13c7e9494d1fa4083f6324e476bf043524eb94b19163af"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "893f2407d4e9b25cb4d3c4ffcb6fa5c10b29274fb337c5d6f941fac2a17ea898"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "158b1575bc26b3115841208eeb7a9f3bcb963dc0ca2ceb27affa0b098945083b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69f4b6d1b4701a39abe57551a70ba0b0d12a222bf50eeee70f873f3f263cb4b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3d351f2f3afd5b380bea7ec578e1f161b2a069466281937117ff3765813aebf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38f47c9de71526e54ffdf94b62e03c7ca145e85a54a15321280ede16d30d72e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86f0a58b571c4f8ed35fe23a9fa3204d8134a037fe0cfbcd4c96c28c476a5df7"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end
