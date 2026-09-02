class Sf < Formula
  desc "Command-line toolkit for Salesforce development"
  homepage "https://developer.salesforce.com/tools/salesforcecli"
  url "https://registry.npmjs.org/@salesforce/cli/-/cli-2.150.6.tgz"
  sha256 "11ede48cb63d613d42acdb16b1622a047666a5cd80eefabdf612f9c53782d50e"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@salesforce/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c44776974d24fe163b1850f4d3c4e749d8fc8fdf852f68ccf302e8e489e53535"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c44776974d24fe163b1850f4d3c4e749d8fc8fdf852f68ccf302e8e489e53535"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c44776974d24fe163b1850f4d3c4e749d8fc8fdf852f68ccf302e8e489e53535"
    sha256 cellar: :any_skip_relocation, sonoma:        "c44776974d24fe163b1850f4d3c4e749d8fc8fdf852f68ccf302e8e489e53535"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71681e632803a2c9c8d7eb78541119c1467ca1c99e766cc5223e47c1f425df7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71681e632803a2c9c8d7eb78541119c1467ca1c99e766cc5223e47c1f425df7f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"sf", "project", "generate", "-n", "projectname", "-t", "empty"
    assert_path_exists testpath/"projectname"
    assert_path_exists testpath/"projectname/config/project-scratch-def.json"
    assert_path_exists testpath/"projectname/README.md"
    assert_path_exists testpath/"projectname/sfdx-project.json"
    assert_path_exists testpath/"projectname/.forceignore"
  end
end
