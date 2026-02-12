class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.7.0.tgz"
  sha256 "70d0cf987892d2f06f5c3091c484df6bb8ea31d28ae9e2eee6525d4b3d9b644c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14de0fa668c3fc36afdb2e7a1b0b9bb9ff67cf65e9a9a3af29d006470c56e851"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14de0fa668c3fc36afdb2e7a1b0b9bb9ff67cf65e9a9a3af29d006470c56e851"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14de0fa668c3fc36afdb2e7a1b0b9bb9ff67cf65e9a9a3af29d006470c56e851"
    sha256 cellar: :any_skip_relocation, sonoma:        "df6f63cd5805ead173ba860dd70ff5a2e6e23ecbf8076f52770fe4cd92e4e74c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "318773263a854bf00a90298f1d1157a33471a878cdacc523f717335387b68a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "318773263a854bf00a90298f1d1157a33471a878cdacc523f717335387b68a60"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end
