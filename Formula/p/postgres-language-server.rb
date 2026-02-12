class PostgresLanguageServer < Formula
  desc "Language Server for Postgres"
  homepage "https://pg-language-server.com/"
  url "https://github.com/supabase-community/postgres-language-server/archive/refs/tags/0.21.0.tar.gz"
  sha256 "e43461f0c98f3fdb9f42b0fd3b4d7c54f4095513e802eac0cd421e4f2e6cc767"
  license "MIT"
  head "https://github.com/supabase-community/postgres-language-server.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d76b44bdbec67e91ec3ece32f8eb4c6877366d6a638a47202ca41de43c5a6b61"
    sha256 cellar: :any,                 arm64_sequoia: "b587b990016609f1287440f10dcd899d285ea693af82b7e83defd03b9be24f70"
    sha256 cellar: :any,                 arm64_sonoma:  "999fef9ce66efa7b927b2777a46454cf74f371280e4c2932153fde146be49ff5"
    sha256 cellar: :any,                 sonoma:        "e7553d3679a62ce23081eb6512ee005438f2456e5ee247a8fbceed2ea0e67710"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ed3d4f02e1797a5fae89ec8f8137a686b7000e3ddc5c170991a0528a8ca2d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad176e7f21fc2cef963eb6e8abf205d608541efad2d89072fe0a01234f856880"
  end

  depends_on "llvm" => :build
  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "tree-sitter" => :build
  depends_on "libpg_query"

  def install
    ENV["PGLS_VERSION"] = version.to_s
    ENV["LIBPG_QUERY_PATH"] = Formula["libpg_query"].opt_prefix
    system "cargo", "install", *std_cargo_args(path: "crates/pgls_cli")
  end

  test do
    (testpath/"test.sql").write("selet 1;")
    output = shell_output("#{bin}/postgres-language-server check #{testpath}/test.sql", 1)
    assert_includes output, "Checked 1 file"
    assert_match version.to_s, shell_output("#{bin}/postgres-language-server --version")
  end
end
