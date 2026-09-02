class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.42.0.tar.gz"
  sha256 "33828227bc17953f7adae5bb0877f47e9c1ff56d0b1f9282b78949fee2b94eb3"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26682b56b042402e3346ae8f67c91c51201a31f4e97e7fa1ac80fb549d3b7299"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26682b56b042402e3346ae8f67c91c51201a31f4e97e7fa1ac80fb549d3b7299"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26682b56b042402e3346ae8f67c91c51201a31f4e97e7fa1ac80fb549d3b7299"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a52006d94a5eaf4ccf0a4e58b4bd2c00b2898bfa2ffd489ebc3d46b0cb8ca84d"
    sha256 cellar: :any,                 x86_64_linux:  "304f6c231648c5eefccc1a1098fe4f7ea871783d55620ea37ed7fed93be86c5d"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
    generate_completions_from_executable(bin/"cloudquery", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cloudquery", "init", "--source", "aws", "--destination", "bigquery"

    assert_path_exists testpath/"cloudquery.log"
    assert_match <<~YAML, (testpath/"aws_to_bigquery.yaml").read
      kind: source
      spec:
        # Source spec section
        name: aws
        path: cloudquery/aws
    YAML

    assert_match version.to_s, shell_output("#{bin}/cloudquery --version")
  end
end
