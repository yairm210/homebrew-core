class Vacuum < Formula
  desc "World's fastest OpenAPI & Swagger linter"
  homepage "https://quobix.com/vacuum/"
  url "https://github.com/daveshanley/vacuum/archive/refs/tags/v0.30.2.tar.gz"
  sha256 "fb8c0f1504dafd3e13641e124bee1dbc58088684d02e5d0dfada15856561988e"
  license "MIT"
  head "https://github.com/daveshanley/vacuum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bbeae67bc266b4de6abb3f39f1c0b579e90b2a85620e6120c95c832a75b5a64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d84de4e57b5b2439bfdc7147714c9c1a82da7bac248f4b7ce95dca704d9060d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5d8a579576045584f01acb17fad96cec73c557bdba6af8ae8589eb3a09d293e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7652f75214bdcbec243b7aca2ce6fd779375a506bb884f5f77ed1479d824d30"
    sha256 cellar: :any,                 x86_64_linux:  "17e01a3f91076cb9b5a10f8a031a35d0acf630fc008d6719d488eeeca00a5a2e"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "html-report/ui" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, tags: "html_report_ui")

    generate_completions_from_executable(bin/"vacuum", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vacuum version")

    (testpath/"test-openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
      paths:
        /test:
          get:
            responses:
              '200':
                description: Successful response
    YAML

    output = shell_output("#{bin}/vacuum lint #{testpath}/test-openapi.yml 2>&1", 1)
    assert_match "Failed with 2 errors, 3 warnings and 0 informs.", output

    output = shell_output("#{bin}/vacuum html-report 2>&1", 2)
    assert_match "please supply an OpenAPI", output
    assert_match "generate an HTML Report", output
    refute_match "html-report support is not included in this build", output
  end
end
