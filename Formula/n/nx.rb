class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-23.2.0.tgz"
  sha256 "edc02089226dc54b9f29b8c027915e176c4e2b2c7a7c274e29f46baad667d53a"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "730eac2231fe9df4fe4a98b5c62136d33dba525623e6ce37c3a32fe312d142dd"
    sha256 cellar: :any,                 arm64_sequoia: "730eac2231fe9df4fe4a98b5c62136d33dba525623e6ce37c3a32fe312d142dd"
    sha256 cellar: :any,                 arm64_sonoma:  "730eac2231fe9df4fe4a98b5c62136d33dba525623e6ce37c3a32fe312d142dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06f9831449734787bfffac64187dace6da9fbd0f2f71fde296a6b143de39ecd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0698c63c33339c7bae8e1f11703f4b2e887ed37def9bd56b9313a1a393164312"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "@acme/repo",
        "version": "0.0.1",
        "scripts": {
          "test": "echo 'Tests passed'"
        }
      }
    JSON

    system bin/"nx", "init", "--no-interactive"
    assert_path_exists testpath/"nx.json"

    output = shell_output("#{bin}/nx test").gsub(/\e\[[0-9;]*m/, "")
    assert_match "Successfully ran target test for project @acme/repo", output
  end
end
