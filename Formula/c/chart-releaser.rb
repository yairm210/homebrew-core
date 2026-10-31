class ChartReleaser < Formula
  desc "Hosting Helm Charts via GitHub Pages and Releases"
  homepage "https://github.com/helm/chart-releaser/"
  url "https://github.com/helm/chart-releaser/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "fb785f8c1a74b8abff39b1ac843ba6d6e7403d824bc2113785131d31fecdd561"
  license "Apache-2.0"
  head "https://github.com/helm/chart-releaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9b7b0e9fc1866d239f00a03905197b8fcd75e11b664499bc6d322135840fa6e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d3c1121a01a00f89037b0781ec5431ed30772cc2c0c0af1d7606f2ee5d83120"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "99ce19735f00b3e953f619a937c0db90f7a5d9771188ae8df05008c0576534e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "40f87c5c3939fe82ee32978b97dda4269e173355ee77ccb35ea9dcfe809624c1"
    sha256 cellar: :any,                 x86_64_linux:      "4d2bfda05fbe0df611e2b6a55c5d49723bd7c4f01a4a3b3b890621034a7fe97c"
  end

  depends_on "go" => :build
  depends_on "helm" => :test

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/helm/chart-releaser/cr/cmd.Version=#{version}
      -X github.com/helm/chart-releaser/cr/cmd.GitCommit=#{tap.user}
      -X github.com/helm/chart-releaser/cr/cmd.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cr"), "./cr"
    generate_completions_from_executable(bin/"cr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cr version")

    system "helm", "create", "testchart"
    system bin/"cr", "package", "--package-path", testpath/"packages", testpath/"testchart"
    assert_path_exists testpath/"packages/testchart-0.1.0.tgz"
  end
end
