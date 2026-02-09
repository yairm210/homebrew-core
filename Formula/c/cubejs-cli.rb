class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.10.tgz"
  sha256 "b81db7106937a26aecd1430a2bc33e2da152da60729b98b76bf8dce63c2a310c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e59ba470307712d333d6760b348945535051f5fb842628ced43fea1cbd3e0828"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01911a4666faa4c3a66d36345a197da1db227b2af190d6e124965922bb128934"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01911a4666faa4c3a66d36345a197da1db227b2af190d6e124965922bb128934"
    sha256 cellar: :any_skip_relocation, sonoma:        "95100f0c4d862f54534aea34fa5a682f26b1b9dcc8f0434b673365cc7ea177d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edcb2579a59d62906f406fc41f04f8bb3ed3b3589b219ad3aa2028a9e3c42e8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edcb2579a59d62906f406fc41f04f8bb3ed3b3589b219ad3aa2028a9e3c42e8c"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
