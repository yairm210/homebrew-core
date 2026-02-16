class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "1a2146730cd75b403180c27e92d7d8da61d66ee16e7a767a6d26ddcbf6837e46"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abeaa7d992e4a011ef3ea43ecc73ae32269720e01eb24c599413c2f76eeebd55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bd0fac46c3752eeea41a1883e8eb3477424c7ff56c38d4c99555572e885928b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27798198388d9bba6f0f0e3723519e4b48faf894dfa31584c98300f99b3d2b93"
    sha256 cellar: :any_skip_relocation, sonoma:        "7776379c2525508f15f132d126cedd2286f7f4dc88b3ea7c4b75eed27b713435"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2806a07eeb31b3ffc9410c1530ca3379285d43465f5b7fa7377fa01cd215c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03e8ca647e550609df71c818a6bd287804149027f5a38a777315ccf6afd2389e"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"config.json").write <<~JSON
      {
        "plugins": {}
      }
    JSON

    init_json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "protocolVersion": "2024-11-05",
          "capabilities": {
            "roots": {},
            "sampling": {},
            "experimental": {}
          },
          "clientInfo": {
            "name": "hyper-mcp",
            "version": "#{version}"
          }
        }
      }
    JSON

    require "open3"
    Open3.popen3(bin/"hyper-mcp", "--config-file", testpath/"config.json") do |stdin, stdout, _, w|
      sleep 2
      stdin.puts JSON.generate(JSON.parse(init_json))
      Timeout.timeout(10) do
        stdout.each do |line|
          break if line.include? "\"version\":\"#{version}\""
        end
      end
      stdin.close
    ensure
      Process.kill "TERM", w.pid
    end
  end
end
