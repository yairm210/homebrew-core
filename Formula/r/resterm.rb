class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "f0b27369e7bd427de7f5ef9db00ca07ef6a516811c0059e97828b384222ccdbc"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cad19abf894d1c993713ee3ce4c12e9739d83ef8789e052d04a08a8d7cc3682"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cad19abf894d1c993713ee3ce4c12e9739d83ef8789e052d04a08a8d7cc3682"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cad19abf894d1c993713ee3ce4c12e9739d83ef8789e052d04a08a8d7cc3682"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d470ee46bb8bf7671b50e1bb189485c0548850326f0c019e06b92ad684021d3"
    sha256 cellar: :any,                 x86_64_linux:  "c056e99b55ce78c55a7e6f876ff04936d76fabb3fc2847a6af639e126b45e423"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/resterm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/resterm -version")

    (testpath/"openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
        description: A simple test API
      servers:
        - url: https://api.example.com
          description: Production server
      paths:
        /ping:
          get:
            summary: Ping endpoint
            operationId: ping
            responses:
              "200":
                description: Successful response
                content:
                  application/json:
                    schema:
                      type: object
                      properties:
                        message:
                          type: string
                          example: "pong"
      components:
        schemas:
          PingResponse:
            type: object
            properties:
              message:
                type: string
    YAML

    system bin/"resterm", "--from-openapi", testpath/"openapi.yml",
                          "--http-out",     testpath/"out.http",
                          "--openapi-base-var", "apiBase",
                          "--openapi-server-index", "0"

    assert_match "GET {{apiBase}}/ping", (testpath/"out.http").read
  end
end
