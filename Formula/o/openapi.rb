class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "32eed48f76ea189eaa486223602c0e7af108fd0155d867f0db5070b3b6a21a88"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf1a8e1a506eed524db57a745d1524d1bf95d4a204489c38f8b09099c81b5982"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf1a8e1a506eed524db57a745d1524d1bf95d4a204489c38f8b09099c81b5982"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf1a8e1a506eed524db57a745d1524d1bf95d4a204489c38f8b09099c81b5982"
    sha256 cellar: :any_skip_relocation, sonoma:        "8465811208cfc49489b78dc951645a3fbd07ccfdde105eff2a7ce19f27b16151"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21c2afb7f811ce285dd598e66951f666582ecb66924cba85065ccf910832754c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90609bc593d2e2d48e2e98613c32512b410d7125fb977ea579638444f6afb956"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openapi"

    generate_completions_from_executable(bin/"openapi", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openapi --version")

    system bin/"openapi", "spec", "bootstrap", "test-api.yaml"
    assert_path_exists testpath/"test-api.yaml"

    system bin/"openapi", "spec", "validate", "test-api.yaml"
  end
end
