class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-23.1.3.tgz"
  sha256 "173610258b62cc229f75f55a4a278993daeb005aa406efb556ab7542b06abf16"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "59d77580d31a1a487ff726eb976fbcc38477f4bc0105a65df6c5e37beb508a30"
    sha256 cellar: :any,                 arm64_sequoia: "59d77580d31a1a487ff726eb976fbcc38477f4bc0105a65df6c5e37beb508a30"
    sha256 cellar: :any,                 arm64_sonoma:  "59d77580d31a1a487ff726eb976fbcc38477f4bc0105a65df6c5e37beb508a30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3737ccb67914acaf6ee8d3503471fbf4fcbd0cb61aec3c07769217daf5251f30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d564815708e5313e10e59a536f42648a914e454fbc1be96d463a56afa620a5a2"
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
