class NotionMcpServer < Formula
  desc "MCP Server for Notion"
  homepage "https://github.com/makenotion/notion-mcp-server"
  url "https://registry.npmjs.org/@notionhq/notion-mcp-server/-/notion-mcp-server-2.1.0.tgz"
  sha256 "bd20ffff1352c0ab156c898a8f30299d78e67560f327b058a895ce6558b992e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "afa19d72cb71ca74c9edacc8e6ca720c7d041b7db37ed2d2ca397841a55367b3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Identifier for a Notion data source", pipe_output(bin/"notion-mcp-server", json, 0)
  end
end
