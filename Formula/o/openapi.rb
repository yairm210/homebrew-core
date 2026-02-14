class Openapi < Formula
  desc "CLI tools for working with OpenAPI, Arazzo and Overlay specifications"
  homepage "https://github.com/speakeasy-api/openapi"
  url "https://github.com/speakeasy-api/openapi/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "2bae92b51c9937c460d77de636505d2ddef4a98b3378639f0bcfacf58f012cb4"
  license "MIT"
  head "https://github.com/speakeasy-api/openapi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "163aa5d635908ebc49e12774b7b81cf2baf34f9f522b38e6a0ae15b772ac9302"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "163aa5d635908ebc49e12774b7b81cf2baf34f9f522b38e6a0ae15b772ac9302"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "163aa5d635908ebc49e12774b7b81cf2baf34f9f522b38e6a0ae15b772ac9302"
    sha256 cellar: :any_skip_relocation, sonoma:        "82286fd59506504533a88dd1da6ca9a0b33e6acaa3b125bfb7bd90eab12548a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa2a9c2d9fd62ba68005eddbb6c543696098c4d5b54c45dd2c2735e1c83c7cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69b4e47637ea92ca89d7d6dbd6334bad12ce7edfe4a3e4deb6df1c48562d47cd"
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
